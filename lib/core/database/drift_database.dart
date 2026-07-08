import 'package:drift/drift.dart';

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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

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
