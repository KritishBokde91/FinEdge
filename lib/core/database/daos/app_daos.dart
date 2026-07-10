import 'package:drift/drift.dart';
import '../drift_database.dart';

part 'app_daos.g.dart';

@DriftAccessor(tables: [AccountBalancesTable])
class AccountBalanceDao extends DatabaseAccessor<AppDatabase>
    with _$AccountBalanceDaoMixin {
  AccountBalanceDao(super.db);

  Future<int> insertBalance(AccountBalancesTableCompanion entry) => into(
    accountBalancesTable,
  ).insert(entry, mode: InsertMode.insertOrReplace);

  Future<List<AccountBalancesTableData>> getAllBalances() =>
      select(accountBalancesTable).get();

  Stream<List<AccountBalancesTableData>> watchAllBalances() =>
      select(accountBalancesTable).watch();

  Future<AccountBalancesTableData?> getBalanceById(int id) => (select(
    accountBalancesTable,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<bool> updateBalance(AccountBalancesTableCompanion entry) =>
      update(accountBalancesTable).replace(entry);

  Future<int> deleteBalance(AccountBalancesTableCompanion entry) =>
      delete(accountBalancesTable).delete(entry);
}

@DriftAccessor(
  tables: [BudgetMonthSnapshotsTable, BudgetCategoryMonthSnapshotsTable],
)
class BudgetSnapshotDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetSnapshotDaoMixin {
  BudgetSnapshotDao(super.db);

  Future<int> insertMonthSnapshot(BudgetMonthSnapshotsTableCompanion entry) =>
      into(
        budgetMonthSnapshotsTable,
      ).insert(entry, mode: InsertMode.insertOrReplace);

  Future<int> insertCategorySnapshot(
    BudgetCategoryMonthSnapshotsTableCompanion entry,
  ) => into(
    budgetCategoryMonthSnapshotsTable,
  ).insert(entry, mode: InsertMode.insertOrReplace);

  Future<List<BudgetMonthSnapshotsTableData>> getAllMonthSnapshots() =>
      select(budgetMonthSnapshotsTable).get();
}

@DriftAccessor(tables: [ChatMessagesTable])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.db);

  Future<int> insertMessage(ChatMessagesTableCompanion entry) =>
      into(chatMessagesTable).insert(entry);

  Future<List<ChatMessagesTableData>> getAllMessages() =>
      select(chatMessagesTable).get();

  Future<void> clearChatHistory() => delete(chatMessagesTable).go();
}

@DriftAccessor(tables: [MerchantMappingsTable])
class MerchantMappingDao extends DatabaseAccessor<AppDatabase>
    with _$MerchantMappingDaoMixin {
  MerchantMappingDao(super.db);

  Future<int> insertMapping(MerchantMappingsTableCompanion entry) => into(
    merchantMappingsTable,
  ).insert(entry, mode: InsertMode.insertOrReplace);

  Future<MerchantMappingsTableData?> getMappingByRaw(String raw) => (select(
    merchantMappingsTable,
  )..where((t) => t.rawMerchant.equals(raw))).getSingleOrNull();
  Future<List<MerchantMappingsTableData>> getAllMappings() =>
      select(merchantMappingsTable).get();
}

@DriftAccessor(tables: [RulesTable])
class RuleDao extends DatabaseAccessor<AppDatabase> with _$RuleDaoMixin {
  RuleDao(super.db);

  Future<int> insertRule(RulesTableCompanion entry) =>
      into(rulesTable).insert(entry);

  Future<List<RulesTableData>> getAllRules() => select(rulesTable).get();

  Stream<List<RulesTableData>> watchAllRules() => select(rulesTable).watch();

  Future<int> deleteRule(String id) =>
      (delete(rulesTable)..where((t) => t.id.equals(id))).go();
}

@DriftAccessor(tables: [TransactionGroupsTable])
class TransactionGroupDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionGroupDaoMixin {
  TransactionGroupDao(super.db);

  Future<int> insertGroup(TransactionGroupsTableCompanion entry) =>
      into(transactionGroupsTable).insert(entry);

  Future<List<TransactionGroupsTableData>> getAllGroups() =>
      select(transactionGroupsTable).get();
}

@DriftAccessor(tables: [BankNotificationsTable])
class BankNotificationDao extends DatabaseAccessor<AppDatabase>
    with _$BankNotificationDaoMixin {
  BankNotificationDao(super.db);

  Future<int> insertNotification(BankNotificationsTableCompanion entry) =>
      into(bankNotificationsTable).insert(entry);

  Future<List<BankNotificationsTableData>> getAllNotifications() =>
      select(bankNotificationsTable).get();
}

@DriftAccessor(tables: [CardsTable])
class CardDao extends DatabaseAccessor<AppDatabase> with _$CardDaoMixin {
  CardDao(super.db);

  Future<int> insertCard(CardsTableCompanion entry) =>
      into(cardsTable).insert(entry, mode: InsertMode.insertOrReplace);

  Future<List<CardsTableData>> getAllActiveCards() =>
      (select(cardsTable)..where((t) => t.isActive.equals(true))).get();
}

@DriftAccessor(tables: [ExchangeRatesTable])
class ExchangeRateDao extends DatabaseAccessor<AppDatabase>
    with _$ExchangeRateDaoMixin {
  ExchangeRateDao(super.db);

  Future<int> insertExchangeRate(ExchangeRatesTableCompanion entry) =>
      into(exchangeRatesTable).insert(entry, mode: InsertMode.insertOrReplace);

  Future<ExchangeRatesTableData?> getRate(String from, String to) =>
      (select(exchangeRatesTable)..where(
            (t) => t.fromCurrency.equals(from) & t.toCurrency.equals(to),
          ))
          .getSingleOrNull();
}

@DriftAccessor(tables: [ProfilesTable])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  Future<int> insertProfile(ProfilesTableCompanion entry) =>
      into(profilesTable).insert(entry);

  Future<List<ProfilesTableData>> getAllProfiles() =>
      select(profilesTable).get();
}

@DriftAccessor(tables: [SubscriptionsTable])
class SubscriptionDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionDaoMixin {
  SubscriptionDao(super.db);

  Future<int> insertSubscription(SubscriptionsTableCompanion entry) =>
      into(subscriptionsTable).insert(entry, mode: InsertMode.insertOrReplace);

  Future<List<SubscriptionsTableData>> getAllSubscriptions() =>
      select(subscriptionsTable).get();
}

@DriftAccessor(tables: [TransactionSplitsTable])
class TransactionSplitDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionSplitDaoMixin {
  TransactionSplitDao(super.db);

  Future<int> insertSplit(TransactionSplitsTableCompanion entry) =>
      into(transactionSplitsTable).insert(entry);

  Future<List<TransactionSplitsTableData>> getSplitsForTransaction(
    String txId,
  ) => (select(
    transactionSplitsTable,
  )..where((t) => t.transactionId.equals(txId))).get();
}

@DriftAccessor(tables: [BudgetsTable, BudgetCategoriesTable])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Future<int> insertBudget(BudgetsTableCompanion entry) =>
      into(budgetsTable).insert(entry, mode: InsertMode.insertOrReplace);

  Future<int> insertCategoryLimit(BudgetCategoriesTableCompanion entry) => into(
    budgetCategoriesTable,
  ).insert(entry, mode: InsertMode.insertOrReplace);

  Future<List<BudgetsTableData>> getAllBudgets() => select(budgetsTable).get();
}

@DriftAccessor(tables: [CategoriesTable])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<int> insertCategory(CategoriesTableCompanion entry) =>
      into(categoriesTable).insert(entry, mode: InsertMode.insertOrIgnore);

  Future<List<CategoriesTableData>> getAllCategories() =>
      select(categoriesTable).get();
}

@DriftAccessor(tables: [LoansTable])
class LoanDao extends DatabaseAccessor<AppDatabase> with _$LoanDaoMixin {
  LoanDao(super.db);

  Future<int> insertLoan(LoansTableCompanion entry) =>
      into(loansTable).insert(entry);

  Future<List<LoansTableData>> getAllActiveLoans() =>
      (select(loansTable)..where((t) => t.active.equals(true))).get();
}

@DriftAccessor(tables: [RuleApplicationsTable])
class RuleApplicationDao extends DatabaseAccessor<AppDatabase>
    with _$RuleApplicationDaoMixin {
  RuleApplicationDao(super.db);

  Future<int> insertApplication(RuleApplicationsTableCompanion entry) =>
      into(ruleApplicationsTable).insert(entry);

  Future<List<RuleApplicationsTableData>> getApplicationsForRule(
    String ruleId,
  ) => (select(
    ruleApplicationsTable,
  )..where((t) => t.ruleId.equals(ruleId))).get();

  Future<int> deleteApplicationsForTransaction(String transactionId) => (delete(
    ruleApplicationsTable,
  )..where((t) => t.transactionId.equals(transactionId))).go();
}

@DriftAccessor(tables: [TransactionsTable])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<int> insertTransaction(TransactionsTableCompanion entry) =>
      into(transactionsTable).insert(entry, mode: InsertMode.insertOrReplace);

  Future<List<TransactionsTableData>> getAllTransactions() =>
      select(transactionsTable).get();

  Stream<List<TransactionsTableData>> watchAllTransactions() =>
      select(transactionsTable).watch();
}

@DriftAccessor(tables: [UnrecognizedSmsTable])
class UnrecognizedSmsDao extends DatabaseAccessor<AppDatabase>
    with _$UnrecognizedSmsDaoMixin {
  UnrecognizedSmsDao(super.db);

  Future<int> insertUnrecognized(UnrecognizedSmsTableCompanion entry) =>
      into(unrecognizedSmsTable).insert(entry);

  Future<List<UnrecognizedSmsTableData>> getAllUnrecognized() =>
      select(unrecognizedSmsTable).get();
}
