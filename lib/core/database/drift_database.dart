import 'package:drift/drift.dart';
import 'daos/app_daos.dart';

part 'drift_database.g.dart';

class SmsMetadataTable extends Table {
  TextColumn get id => text()();
  TextColumn get sender => text()();
  TextColumn get body => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isProcessed => boolean().withDefault(const Constant(false))();
  RealColumn get confidence => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class TransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get smsId => text().nullable().references(SmsMetadataTable, #id)();
  RealColumn get amount => real()();
  TextColumn get merchant => text()();
  TextColumn get category => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isIncome => boolean()();
  TextColumn get accountSource => text()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get reference => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BudgetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  RealColumn get limitAmount => real()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SubscriptionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get merchant => text()();
  RealColumn get amount => real()();
  TextColumn get billingCycle => text()();
  DateTimeColumn get nextBillingDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class FraudAlertsTable extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text().references(TransactionsTable, #id)();
  RealColumn get riskScore => real()();
  TextColumn get reason => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class AiInsightsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class GoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real()();
  DateTimeColumn get targetDate => dateTime()();
  TextColumn get category => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class NotificationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get type => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ExchangeRatesTable extends Table {
  TextColumn get id => text()();
  TextColumn get fromCurrency => text()();
  TextColumn get toCurrency => text()();
  RealColumn get rate => real()();
  TextColumn get provider => text()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
  BoolColumn get isCustomRate => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ProfilesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get color => text()();
}

class CategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  TextColumn get color => text().nullable()();
}

class CardsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bankName => text()();
  TextColumn get cardLast4 => text()();
  TextColumn get accountLast4 => text().nullable()();
  TextColumn get cardType => text()(); // e.g. DEBIT, CREDIT
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  RealColumn get creditLimit => real().nullable()();
}

class AccountBalancesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bankName => text()();
  TextColumn get accountLast4 => text()();
  RealColumn get balance => real()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get transactionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  RealColumn get creditLimit => real().nullable()();
  BoolColumn get isCreditCard => boolean().withDefault(const Constant(false))();
  TextColumn get smsSource => text().nullable()();
  TextColumn get sourceType => text().nullable()(); // e.g. OPENING, MANUAL, SMS
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  IntColumn get profileId => integer().nullable()();
  TextColumn get alias => text().nullable()();
  RealColumn get lowBalanceThreshold => real().nullable()();
}

class MerchantMappingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get rawMerchant => text()();
  TextColumn get cleanMerchant => text()();
}

class UnrecognizedSmsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get smsId => text()();
  TextColumn get body => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get reason => text()();
}

class ChatMessagesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => text()(); // e.g. user, assistant, system
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
}

class RulesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(100))();
  TextColumn get conditions => text()(); // JSON string
  TextColumn get actions => text()(); // JSON string
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSystemTemplate => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class RuleApplicationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get ruleId => text().references(RulesTable, #id)();
  TextColumn get ruleName => text()();
  TextColumn get transactionId => text().references(TransactionsTable, #id)();
  TextColumn get fieldsModified => text()(); // JSON string
  DateTimeColumn get appliedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TransactionSplitsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get transactionId => text()();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
}

class BankNotificationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get timestamp => dateTime()();
}

class LoansTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lender => text()();
  RealColumn get principal => real()();
  RealColumn get interestRate => real()();
  DateTimeColumn get startDate => dateTime()();
  IntColumn get durationMonths => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class TransactionGroupsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class BudgetMonthSnapshotsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get budgetId => integer()();
  RealColumn get spentAmount => real()();
  TextColumn get month => text()(); // e.g. YYYY-MM
}

class BudgetCategoryMonthSnapshotsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get budgetId => integer()();
  TextColumn get category => text()();
  RealColumn get spentAmount => real()();
  TextColumn get month => text()();
}

class BudgetCategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get budgetId => integer()();
  TextColumn get category => text()();
  RealColumn get limitAmount => real()();
}

@DriftDatabase(
  tables: [
    SmsMetadataTable,
    TransactionsTable,
    BudgetsTable,
    SubscriptionsTable,
    FraudAlertsTable,
    AiInsightsTable,
    GoalsTable,
    NotificationsTable,
    ExchangeRatesTable,
    ProfilesTable,
    CategoriesTable,
    CardsTable,
    AccountBalancesTable,
    MerchantMappingsTable,
    UnrecognizedSmsTable,
    ChatMessagesTable,
    RulesTable,
    RuleApplicationsTable,
    TransactionSplitsTable,
    BankNotificationsTable,
    LoansTable,
    TransactionGroupsTable,
    BudgetMonthSnapshotsTable,
    BudgetCategoryMonthSnapshotsTable,
    BudgetCategoriesTable,
  ],
  daos: [
    AccountBalanceDao,
    BudgetSnapshotDao,
    ChatDao,
    MerchantMappingDao,
    RuleDao,
    TransactionGroupDao,
    BankNotificationDao,
    CardDao,
    ExchangeRateDao,
    ProfileDao,
    SubscriptionDao,
    TransactionSplitDao,
    BudgetDao,
    CategoryDao,
    LoanDao,
    RuleApplicationDao,
    TransactionDao,
    UnrecognizedSmsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Recreate tables to make developer migrations instant and reliable
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
          }
          await m.createAll();
        },
      );
}
