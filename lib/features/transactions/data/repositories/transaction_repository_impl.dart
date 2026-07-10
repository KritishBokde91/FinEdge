import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/logger/app_logger.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../../sms_intelligence/domain/services/transaction_deduplication.dart';

extension on TransactionsTableData {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      smsId: smsId,
      amount: amount,
      merchant: merchant,
      category: category,
      timestamp: timestamp,
      isIncome: isIncome,
      accountSource: accountSource,
      reference: reference,
      currency: currency,
    );
  }
}

extension on TransactionEntity {
  TransactionsTableCompanion toCompanion() {
    return TransactionsTableCompanion(
      id: Value(id),
      smsId: Value(smsId),
      amount: Value(amount),
      merchant: Value(merchant),
      category: Value(category),
      timestamp: Value(timestamp),
      isIncome: Value(isIncome),
      accountSource: Value(accountSource),
      reference: Value(reference),
      currency: Value(currency),
    );
  }
}

class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _db;

  const TransactionRepositoryImpl(this._db);

  @override
  Stream<List<TransactionEntity>> watchAllTransactions() {
    return (_db.select(_db.transactionsTable)..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<Result<TransactionEntity>> getTransactionById(String id) async {
    try {
      final query = _db.select(_db.transactionsTable)
        ..where((t) => t.id.equals(id));
      final row = await query.getSingleOrNull();
      if (row == null) {
        return const Left(DatabaseFailure('Transaction not found'));
      }
      return Right(row.toEntity());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch transaction by id', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> insertTransaction(TransactionEntity transaction) async {
    try {
      await _db
          .into(_db.transactionsTable)
          .insert(transaction.toCompanion(), mode: InsertMode.insertOrReplace);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to insert transaction', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateTransaction(TransactionEntity transaction) async {
    try {
      await _db
          .update(_db.transactionsTable)
          .replace(transaction.toCompanion());
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to update transaction', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    try {
      final query = _db.delete(_db.transactionsTable)
        ..where((t) => t.id.equals(id));
      await query.go();
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to delete transaction', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, double>>> calculateCategoryAggregates() async {
    try {
      final amountSum = _db.transactionsTable.amount.sum();
      final query = _db.selectOnly(_db.transactionsTable)
        ..addColumns([_db.transactionsTable.category, amountSum])
        ..groupBy([_db.transactionsTable.category]);

      final rows = await query.get();
      final Map<String, double> aggregates = {};
      for (final row in rows) {
        final category = row.read(_db.transactionsTable.category);
        final sum = row.read(amountSum);
        if (category != null && sum != null) {
          aggregates[category] = sum;
        }
      }
      return Right(aggregates);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to calculate category aggregates', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<List<TransactionEntity>> findPotentialDuplicates(
    TransactionEntity transaction,
  ) async {
    if (!TransactionDeduplication.hasUpiReference(transaction.reference)) {
      return const [];
    }

    const window = TransactionDeduplication.upiDuplicateWindow;
    final start = transaction.timestamp.subtract(window);
    final end = transaction.timestamp.add(window);

    final query = _db.select(_db.transactionsTable)
      ..where(
        (t) =>
            t.reference.equals(transaction.reference!) &
            t.amount.equals(transaction.amount) &
            t.isIncome.equals(transaction.isIncome) &
            t.timestamp.isBiggerOrEqualValue(start) &
            t.timestamp.isSmallerOrEqualValue(end),
      );

    final rows = await query.get();
    final candidates = rows.map((r) => r.toEntity()).toList();

    return candidates.where((candidate) {
      return candidate.id != transaction.id &&
          TransactionDeduplication.isSameUpiTransactionEntity(
            candidate,
            transaction,
          );
    }).toList();
  }
}
