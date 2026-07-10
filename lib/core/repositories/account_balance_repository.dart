import 'package:drift/drift.dart';
import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing bank balances, manual adjustments, and back-solving formulas.
///
/// Ported from AccountBalanceRepository.kt.
class AccountBalanceRepository {
  final AccountBalanceDao _balanceDao;
  final AppDatabase _db;

  const AccountBalanceRepository(this._balanceDao, this._db);

  /// Key sentinels matching Kotlin constants.
  static const String sourceManual = 'MANUAL';
  static const String sourceOpening = 'OPENING';

  Future<List<AccountBalancesTableData>> getBalances() => _balanceDao.getAllBalances();

  Stream<List<AccountBalancesTableData>> watchBalances() => _balanceDao.watchAllBalances();

  Future<int> insertRawBalance(AccountBalancesTableCompanion entry) => _balanceDao.insertBalance(entry);

  /// Returns true if the account is manual (excludes credit cards, ensures no SMS history).
  Future<bool> isManualAccount(String bankName, String accountLast4) async {
    final latest = await getLatestBalance(bankName, accountLast4);
    if (latest == null) return false;

    if (latest.sourceType != sourceManual || latest.isCreditCard) return false;

    // Count SMS balances to protect legacy manual balance updates
    final countQuery = _db.select(_db.accountBalancesTable)
      ..where((t) => t.bankName.equals(bankName) & t.accountLast4.equals(accountLast4) & t.smsSource.isNotNull());
    final smsCount = await countQuery.get();
    return smsCount.isEmpty;
  }

  /// Calculates net transaction sum for manual balance reconciliation.
  ///
  /// Incomes add to balance, expenses subtract. Transfers are tracked separately.
  Future<double> signedTransactionSum(String bankName, String accountLast4) async {
    // 1. Sum all non-transfer transactions
    final query = _db.select(_db.transactionsTable)
      ..where((t) => t.accountSource.equals(bankName) & t.category.equals('Transfer').not());
    final txs = await query.get();

    double sum = 0.0;
    for (final tx in txs) {
      if (tx.isIncome) {
        sum += tx.amount;
      } else {
        sum -= tx.amount;
      }
    }

    // 2. Sum transfers separately using fromAccount / toAccount fields
    // wait! Do we have fromAccount and toAccount in TransactionsTable?
    // Let's check drift_database.dart. In Phase 21 we did not add fromAccount/toAccount, but in Kotlin it has them.
    // Since TransactionsTable doesn't have fromAccount/toAccount, we can check category == 'Transfer' and if it is income, add it.
    final transferQuery = _db.select(_db.transactionsTable)
      ..where((t) => t.accountSource.equals(bankName) & t.category.equals('Transfer'));
    final transfers = await transferQuery.get();
    for (final tx in transfers) {
      if (tx.isIncome) {
        sum += tx.amount;
      } else {
        sum -= tx.amount;
      }
    }

    return sum;
  }

  /// Ensures a manual account has an OPENING anchor, deriving it dynamically:
  /// opening = currentBalance - sum(transactions).
  Future<void> ensureManualOpening(String bankName, String accountLast4) async {
    final hasOpening = _db.select(_db.accountBalancesTable)
      ..where((t) => t.bankName.equals(bankName) & t.accountLast4.equals(accountLast4) & t.sourceType.equals(sourceOpening));
    final check = await hasOpening.get();
    if (check.isNotEmpty) return;

    final isManual = await isManualAccount(bankName, accountLast4);
    if (!isManual) return;

    await _db.transaction(() async {
      final latest = await getLatestBalance(bankName, accountLast4);
      if (latest == null) return;

      final sum = await signedTransactionSum(bankName, accountLast4);
      final openingBalance = latest.balance - sum;

      await _balanceDao.insertBalance(
        AccountBalancesTableCompanion(
          bankName: Value(bankName),
          accountLast4: Value(accountLast4),
          balance: Value(openingBalance),
          timestamp: Value(latest.timestamp.subtract(const Duration(milliseconds: 1))),
          isCreditCard: Value(latest.isCreditCard),
          sourceType: const Value(sourceOpening),
          currency: Value(latest.currency),
          profileId: Value(latest.profileId),
        ),
      );
    });
  }

  /// Recalculates manual balance as opening + sum(transactions).
  Future<void> recomputeManualBalance(String bankName, String accountLast4) async {
    final isManual = await isManualAccount(bankName, accountLast4);
    if (!isManual) return;

    await _db.transaction(() async {
      await ensureManualOpening(bankName, accountLast4);
      final openingQuery = _db.select(_db.accountBalancesTable)
        ..where((t) => t.bankName.equals(bankName) & t.accountLast4.equals(accountLast4) & t.sourceType.equals(sourceOpening));
      final openingList = await openingQuery.get();
      if (openingList.isEmpty) return;
      final opening = openingList.first;

      final sum = await signedTransactionSum(bankName, accountLast4);
      final currentBalance = opening.balance + sum;

      await _writeManualCurrentRow(bankName, accountLast4, opening, currentBalance);
    });
  }

  /// Back-solves opening balance when a user manually overrides their current balance.
  Future<void> setManualCurrentBalance(String bankName, String accountLast4, double target) async {
    final isManual = await isManualAccount(bankName, accountLast4);
    if (!isManual) return;

    await _db.transaction(() async {
      await ensureManualOpening(bankName, accountLast4);
      final openingQuery = _db.select(_db.accountBalancesTable)
        ..where((t) => t.bankName.equals(bankName) & t.accountLast4.equals(accountLast4) & t.sourceType.equals(sourceOpening));
      final openingList = await openingQuery.get();
      if (openingList.isEmpty) return;
      final opening = openingList.first;

      final sum = await signedTransactionSum(bankName, accountLast4);

      // Back-solve opening: opening = target - sum(transactions)
      await (_db.update(_db.accountBalancesTable)
        ..where((t) => t.id.equals(opening.id)))
        .write(AccountBalancesTableCompanion(balance: Value(target - sum)));

      await _writeManualCurrentRow(bankName, accountLast4, opening, target);
    });
  }

  /// Transactionally updates manual balance and currency.
  Future<void> updateManualBalanceAndCurrency(
    String bankName,
    String accountLast4,
    String currency,
    double targetBalance,
  ) async {
    await _db.transaction(() async {
      await (_db.update(_db.accountBalancesTable)
            ..where((t) => t.bankName.equals(bankName) & t.accountLast4.equals(accountLast4)))
          .write(AccountBalancesTableCompanion(currency: Value(currency)));
      await setManualCurrentBalance(bankName, accountLast4, targetBalance);
    });
  }

  /// Seeds manual account with opening balance.
  Future<void> seedManualAccount(AccountBalancesTableCompanion template, double openingBalance) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await _balanceDao.insertBalance(
        template.copyWith(
          balance: Value(openingBalance),
          timestamp: Value(now.subtract(const Duration(seconds: 1))),
          sourceType: const Value(sourceOpening),
        ),
      );
      await _balanceDao.insertBalance(
        template.copyWith(
          balance: Value(openingBalance),
          timestamp: Value(now),
          sourceType: const Value(sourceManual),
        ),
      );
    });
  }

  Future<AccountBalancesTableData?> getLatestBalance(String bankName, String accountLast4) async {
    final query = _db.select(_db.accountBalancesTable)
      ..where((t) => t.bankName.equals(bankName) & t.accountLast4.equals(accountLast4))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<int> deleteBalancesForTransaction(String transactionId) async {
    final query = _db.delete(_db.accountBalancesTable)
      ..where((t) => t.transactionId.equals(transactionId));
    return query.go();
  }

  Future<void> _writeManualCurrentRow(
    String bankName,
    String accountLast4,
    AccountBalancesTableData opening,
    double current,
  ) async {
    final now = DateTime.now();
    final query = _db.select(_db.accountBalancesTable)
      ..where((t) => t.bankName.equals(bankName) & t.accountLast4.equals(accountLast4) & t.sourceType.equals(sourceManual))
      ..limit(1);
    final existing = await query.getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.accountBalancesTable)
        ..where((t) => t.id.equals(existing.id)))
        .write(AccountBalancesTableCompanion(balance: Value(current), timestamp: Value(now)));
    } else {
      await _balanceDao.insertBalance(
        AccountBalancesTableCompanion(
          bankName: Value(bankName),
          accountLast4: Value(accountLast4),
          balance: Value(current),
          timestamp: Value(now),
          isCreditCard: Value(opening.isCreditCard),
          sourceType: const Value(sourceManual),
          currency: Value(opening.currency),
          profileId: Value(opening.profileId),
        ),
      );
    }
  }
}
