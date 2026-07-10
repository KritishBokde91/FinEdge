// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_daos.dart';

// ignore_for_file: type=lint
mixin _$AccountBalanceDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccountBalancesTableTable get accountBalancesTable =>
      attachedDatabase.accountBalancesTable;
  AccountBalanceDaoManager get managers => AccountBalanceDaoManager(this);
}

class AccountBalanceDaoManager {
  final _$AccountBalanceDaoMixin _db;
  AccountBalanceDaoManager(this._db);
  $$AccountBalancesTableTableTableManager get accountBalancesTable =>
      $$AccountBalancesTableTableTableManager(
        _db.attachedDatabase,
        _db.accountBalancesTable,
      );
}

mixin _$BudgetSnapshotDaoMixin on DatabaseAccessor<AppDatabase> {
  $BudgetMonthSnapshotsTableTable get budgetMonthSnapshotsTable =>
      attachedDatabase.budgetMonthSnapshotsTable;
  $BudgetCategoryMonthSnapshotsTableTable
  get budgetCategoryMonthSnapshotsTable =>
      attachedDatabase.budgetCategoryMonthSnapshotsTable;
  BudgetSnapshotDaoManager get managers => BudgetSnapshotDaoManager(this);
}

class BudgetSnapshotDaoManager {
  final _$BudgetSnapshotDaoMixin _db;
  BudgetSnapshotDaoManager(this._db);
  $$BudgetMonthSnapshotsTableTableTableManager get budgetMonthSnapshotsTable =>
      $$BudgetMonthSnapshotsTableTableTableManager(
        _db.attachedDatabase,
        _db.budgetMonthSnapshotsTable,
      );
  $$BudgetCategoryMonthSnapshotsTableTableTableManager
  get budgetCategoryMonthSnapshotsTable =>
      $$BudgetCategoryMonthSnapshotsTableTableTableManager(
        _db.attachedDatabase,
        _db.budgetCategoryMonthSnapshotsTable,
      );
}

mixin _$ChatDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChatMessagesTableTable get chatMessagesTable =>
      attachedDatabase.chatMessagesTable;
  ChatDaoManager get managers => ChatDaoManager(this);
}

class ChatDaoManager {
  final _$ChatDaoMixin _db;
  ChatDaoManager(this._db);
  $$ChatMessagesTableTableTableManager get chatMessagesTable =>
      $$ChatMessagesTableTableTableManager(
        _db.attachedDatabase,
        _db.chatMessagesTable,
      );
}

mixin _$MerchantMappingDaoMixin on DatabaseAccessor<AppDatabase> {
  $MerchantMappingsTableTable get merchantMappingsTable =>
      attachedDatabase.merchantMappingsTable;
  MerchantMappingDaoManager get managers => MerchantMappingDaoManager(this);
}

class MerchantMappingDaoManager {
  final _$MerchantMappingDaoMixin _db;
  MerchantMappingDaoManager(this._db);
  $$MerchantMappingsTableTableTableManager get merchantMappingsTable =>
      $$MerchantMappingsTableTableTableManager(
        _db.attachedDatabase,
        _db.merchantMappingsTable,
      );
}

mixin _$RuleDaoMixin on DatabaseAccessor<AppDatabase> {
  $RulesTableTable get rulesTable => attachedDatabase.rulesTable;
  RuleDaoManager get managers => RuleDaoManager(this);
}

class RuleDaoManager {
  final _$RuleDaoMixin _db;
  RuleDaoManager(this._db);
  $$RulesTableTableTableManager get rulesTable =>
      $$RulesTableTableTableManager(_db.attachedDatabase, _db.rulesTable);
}

mixin _$TransactionGroupDaoMixin on DatabaseAccessor<AppDatabase> {
  $TransactionGroupsTableTable get transactionGroupsTable =>
      attachedDatabase.transactionGroupsTable;
  TransactionGroupDaoManager get managers => TransactionGroupDaoManager(this);
}

class TransactionGroupDaoManager {
  final _$TransactionGroupDaoMixin _db;
  TransactionGroupDaoManager(this._db);
  $$TransactionGroupsTableTableTableManager get transactionGroupsTable =>
      $$TransactionGroupsTableTableTableManager(
        _db.attachedDatabase,
        _db.transactionGroupsTable,
      );
}

mixin _$BankNotificationDaoMixin on DatabaseAccessor<AppDatabase> {
  $BankNotificationsTableTable get bankNotificationsTable =>
      attachedDatabase.bankNotificationsTable;
  BankNotificationDaoManager get managers => BankNotificationDaoManager(this);
}

class BankNotificationDaoManager {
  final _$BankNotificationDaoMixin _db;
  BankNotificationDaoManager(this._db);
  $$BankNotificationsTableTableTableManager get bankNotificationsTable =>
      $$BankNotificationsTableTableTableManager(
        _db.attachedDatabase,
        _db.bankNotificationsTable,
      );
}

mixin _$CardDaoMixin on DatabaseAccessor<AppDatabase> {
  $CardsTableTable get cardsTable => attachedDatabase.cardsTable;
  CardDaoManager get managers => CardDaoManager(this);
}

class CardDaoManager {
  final _$CardDaoMixin _db;
  CardDaoManager(this._db);
  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db.attachedDatabase, _db.cardsTable);
}

mixin _$ExchangeRateDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExchangeRatesTableTable get exchangeRatesTable =>
      attachedDatabase.exchangeRatesTable;
  ExchangeRateDaoManager get managers => ExchangeRateDaoManager(this);
}

class ExchangeRateDaoManager {
  final _$ExchangeRateDaoMixin _db;
  ExchangeRateDaoManager(this._db);
  $$ExchangeRatesTableTableTableManager get exchangeRatesTable =>
      $$ExchangeRatesTableTableTableManager(
        _db.attachedDatabase,
        _db.exchangeRatesTable,
      );
}

mixin _$ProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProfilesTableTable get profilesTable => attachedDatabase.profilesTable;
  ProfileDaoManager get managers => ProfileDaoManager(this);
}

class ProfileDaoManager {
  final _$ProfileDaoMixin _db;
  ProfileDaoManager(this._db);
  $$ProfilesTableTableTableManager get profilesTable =>
      $$ProfilesTableTableTableManager(_db.attachedDatabase, _db.profilesTable);
}

mixin _$SubscriptionDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubscriptionsTableTable get subscriptionsTable =>
      attachedDatabase.subscriptionsTable;
  SubscriptionDaoManager get managers => SubscriptionDaoManager(this);
}

class SubscriptionDaoManager {
  final _$SubscriptionDaoMixin _db;
  SubscriptionDaoManager(this._db);
  $$SubscriptionsTableTableTableManager get subscriptionsTable =>
      $$SubscriptionsTableTableTableManager(
        _db.attachedDatabase,
        _db.subscriptionsTable,
      );
}

mixin _$TransactionSplitDaoMixin on DatabaseAccessor<AppDatabase> {
  $TransactionSplitsTableTable get transactionSplitsTable =>
      attachedDatabase.transactionSplitsTable;
  TransactionSplitDaoManager get managers => TransactionSplitDaoManager(this);
}

class TransactionSplitDaoManager {
  final _$TransactionSplitDaoMixin _db;
  TransactionSplitDaoManager(this._db);
  $$TransactionSplitsTableTableTableManager get transactionSplitsTable =>
      $$TransactionSplitsTableTableTableManager(
        _db.attachedDatabase,
        _db.transactionSplitsTable,
      );
}

mixin _$BudgetDaoMixin on DatabaseAccessor<AppDatabase> {
  $BudgetsTableTable get budgetsTable => attachedDatabase.budgetsTable;
  $BudgetCategoriesTableTable get budgetCategoriesTable =>
      attachedDatabase.budgetCategoriesTable;
  BudgetDaoManager get managers => BudgetDaoManager(this);
}

class BudgetDaoManager {
  final _$BudgetDaoMixin _db;
  BudgetDaoManager(this._db);
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db.attachedDatabase, _db.budgetsTable);
  $$BudgetCategoriesTableTableTableManager get budgetCategoriesTable =>
      $$BudgetCategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.budgetCategoriesTable,
      );
}

mixin _$CategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  CategoryDaoManager get managers => CategoryDaoManager(this);
}

class CategoryDaoManager {
  final _$CategoryDaoMixin _db;
  CategoryDaoManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.categoriesTable,
      );
}

mixin _$LoanDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoansTableTable get loansTable => attachedDatabase.loansTable;
  LoanDaoManager get managers => LoanDaoManager(this);
}

class LoanDaoManager {
  final _$LoanDaoMixin _db;
  LoanDaoManager(this._db);
  $$LoansTableTableTableManager get loansTable =>
      $$LoansTableTableTableManager(_db.attachedDatabase, _db.loansTable);
}

mixin _$RuleApplicationDaoMixin on DatabaseAccessor<AppDatabase> {
  $RulesTableTable get rulesTable => attachedDatabase.rulesTable;
  $SmsMetadataTableTable get smsMetadataTable =>
      attachedDatabase.smsMetadataTable;
  $TransactionsTableTable get transactionsTable =>
      attachedDatabase.transactionsTable;
  $RuleApplicationsTableTable get ruleApplicationsTable =>
      attachedDatabase.ruleApplicationsTable;
  RuleApplicationDaoManager get managers => RuleApplicationDaoManager(this);
}

class RuleApplicationDaoManager {
  final _$RuleApplicationDaoMixin _db;
  RuleApplicationDaoManager(this._db);
  $$RulesTableTableTableManager get rulesTable =>
      $$RulesTableTableTableManager(_db.attachedDatabase, _db.rulesTable);
  $$SmsMetadataTableTableTableManager get smsMetadataTable =>
      $$SmsMetadataTableTableTableManager(
        _db.attachedDatabase,
        _db.smsMetadataTable,
      );
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(
        _db.attachedDatabase,
        _db.transactionsTable,
      );
  $$RuleApplicationsTableTableTableManager get ruleApplicationsTable =>
      $$RuleApplicationsTableTableTableManager(
        _db.attachedDatabase,
        _db.ruleApplicationsTable,
      );
}

mixin _$TransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $SmsMetadataTableTable get smsMetadataTable =>
      attachedDatabase.smsMetadataTable;
  $TransactionsTableTable get transactionsTable =>
      attachedDatabase.transactionsTable;
  TransactionDaoManager get managers => TransactionDaoManager(this);
}

class TransactionDaoManager {
  final _$TransactionDaoMixin _db;
  TransactionDaoManager(this._db);
  $$SmsMetadataTableTableTableManager get smsMetadataTable =>
      $$SmsMetadataTableTableTableManager(
        _db.attachedDatabase,
        _db.smsMetadataTable,
      );
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(
        _db.attachedDatabase,
        _db.transactionsTable,
      );
}

mixin _$UnrecognizedSmsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UnrecognizedSmsTableTable get unrecognizedSmsTable =>
      attachedDatabase.unrecognizedSmsTable;
  UnrecognizedSmsDaoManager get managers => UnrecognizedSmsDaoManager(this);
}

class UnrecognizedSmsDaoManager {
  final _$UnrecognizedSmsDaoMixin _db;
  UnrecognizedSmsDaoManager(this._db);
  $$UnrecognizedSmsTableTableTableManager get unrecognizedSmsTable =>
      $$UnrecognizedSmsTableTableTableManager(
        _db.attachedDatabase,
        _db.unrecognizedSmsTable,
      );
}
