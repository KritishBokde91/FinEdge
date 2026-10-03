import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/backup_models.dart';
import '../../domain/repositories/backup_exporter.dart';
import '../../domain/repositories/backup_importer.dart';

/// Drift implementation of [BackupExporter] and [BackupImporter].
///
/// Ported from BackupExporter.kt / BackupImporter.kt.
class DriftBackupRepository implements BackupExporter, BackupImporter {
  final AppDatabase _db;
  final PreferencesService _prefs;

  const DriftBackupRepository(this._db, this._prefs);

  @override
  Future<ExportResult> exportBackup() async {
    try {
      // 1. Query all tables
      final smsList = await _db.select(_db.smsMetadataTable).get();
      final txList = await _db.select(_db.transactionsTable).get();
      final budgetList = await _db.select(_db.budgetsTable).get();
      final subList = await _db.select(_db.subscriptionsTable).get();
      final goalList = await _db.select(_db.goalsTable).get();
      final alertList = await _db.select(_db.fraudAlertsTable).get();
      final insightList = await _db.select(_db.aiInsightsTable).get();
      final notifyList = await _db.select(_db.notificationsTable).get();

      // 2. Package database snapshot
      final databaseSnapshot = DatabaseSnapshot(
        smsMetadata: smsList.map((e) => e.toJson()).toList(),
        transactions: txList.map((e) => e.toJson()).toList(),
        budgets: budgetList.map((e) => e.toJson()).toList(),
        subscriptions: subList.map((e) => e.toJson()).toList(),
        goals: goalList.map((e) => e.toJson()).toList(),
        notifications: notifyList.map((e) => e.toJson()).toList(),
        fraudAlerts: alertList.map((e) => e.toJson()).toList(),
        aiInsights: insightList.map((e) => e.toJson()).toList(),
      );

      // 3. Package preferences
      final preferencesSnapshot = PreferencesSnapshot(
        themeMode: _prefs.getThemeMode(),
        biometricEnabled: _prefs.isBiometricEnabled(),
        lastSmsSyncTimestamp: _prefs.getLastSmsSyncTimestamp(),
      );

      // 4. Build payload
      final payload = BackupPayload(
        created: DateTime.now().toIso8601String(),
        metadata: const BackupMetadata(
          exportId: 'finsight_export_v1',
          appVersion: '1.0.0',
          databaseVersion: AppConstants.databaseVersion,
        ),
        database: databaseSnapshot,
        preferences: preferencesSnapshot,
      );

      // 5. Serialize and write to file
      final jsonString = const JsonEncoder.withIndent('  ').convert(payload.toJson());
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/finsight_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonString);

      return ExportSuccess(file);
    } catch (e) {
      return ExportError('Export failed: ${e.toString()}');
    }
  }

  @override
  Future<ImportResult> importBackup(String jsonContent) async {
    try {
      final decoded = json.decode(jsonContent) as Map<String, dynamic>;
      final payload = BackupPayload.fromJson(decoded);

      // Check database version compatibility
      if (payload.metadata.databaseVersion > AppConstants.databaseVersion) {
        return ImportError(
          'Database version ${payload.metadata.databaseVersion} is not compatible with local version ${AppConstants.databaseVersion}. Please update the app.',
        );
      }

      int txCount = 0;
      int budgetCount = 0;
      int goalCount = 0;
      int subCount = 0;
      int duplicateCount = 0;

      // Wrap whole import in a single transaction for atomicity (all-or-nothing rollback)
      await _db.transaction(() async {
        // Import SMS Metadata
        for (final item in payload.database.smsMetadata) {
          final row = SmsMetadataTableData.fromJson(item);
          final inserted = await _db.into(_db.smsMetadataTable).insert(
                row,
                mode: InsertMode.insertOrIgnore,
              );
          if (inserted == 0) duplicateCount++;
        }

        // Import Transactions
        for (final item in payload.database.transactions) {
          final row = TransactionsTableData.fromJson(item);
          final inserted = await _db.into(_db.transactionsTable).insert(
                row,
                mode: InsertMode.insertOrIgnore,
              );
          if (inserted > 0) {
            txCount++;
          } else {
            duplicateCount++;
          }
        }

        // Import Budgets
        for (final item in payload.database.budgets) {
          final row = BudgetsTableData.fromJson(item);
          final inserted = await _db.into(_db.budgetsTable).insert(
                row,
                mode: InsertMode.insertOrIgnore,
              );
          if (inserted > 0) {
            budgetCount++;
          } else {
            duplicateCount++;
          }
        }

        // Import Subscriptions
        for (final item in payload.database.subscriptions) {
          final row = SubscriptionsTableData.fromJson(item);
          final inserted = await _db.into(_db.subscriptionsTable).insert(
                row,
                mode: InsertMode.insertOrIgnore,
              );
          if (inserted > 0) {
            subCount++;
          } else {
            duplicateCount++;
          }
        }

        // Import Goals
        for (final item in payload.database.goals) {
          final row = GoalsTableData.fromJson(item);
          final inserted = await _db.into(_db.goalsTable).insert(
                row,
                mode: InsertMode.insertOrIgnore,
              );
          if (inserted > 0) {
            goalCount++;
          } else {
            duplicateCount++;
          }
        }

        // Import Notifications
        for (final item in payload.database.notifications) {
          final row = NotificationsTableData.fromJson(item);
          final inserted = await _db.into(_db.notificationsTable).insert(
                row,
                mode: InsertMode.insertOrIgnore,
              );
          if (inserted == 0) duplicateCount++;
        }

        // Import Fraud Alerts
        for (final item in payload.database.fraudAlerts) {
          final row = FraudAlertsTableData.fromJson(item);
          final inserted = await _db.into(_db.fraudAlertsTable).insert(
                row,
                mode: InsertMode.insertOrIgnore,
              );
          if (inserted == 0) duplicateCount++;
        }

        // Import AI Insights
        for (final item in payload.database.aiInsights) {
          final row = AiInsightsTableData.fromJson(item);
          final inserted = await _db.into(_db.aiInsightsTable).insert(
                row,
                mode: InsertMode.insertOrIgnore,
              );
          if (inserted == 0) duplicateCount++;
        }
      });

      // Restore Preferences (if provided)
      final prefs = payload.preferences;
      if (prefs.themeMode != null) {
        await _prefs.setThemeMode(prefs.themeMode!);
      }
      if (prefs.biometricEnabled != null) {
        await _prefs.setBiometricEnabled(prefs.biometricEnabled!);
      }
      if (prefs.lastSmsSyncTimestamp != null) {
        await _prefs.setLastSmsSyncTimestamp(prefs.lastSmsSyncTimestamp!);
      }

      return ImportSuccess(
        importedTransactions: txCount,
        importedBudgets: budgetCount,
        importedGoals: goalCount,
        importedSubscriptions: subCount,
        skippedDuplicates: duplicateCount,
      );
    } catch (e) {
      return ImportError('Restore failed: ${e.toString()}');
    }
  }
}
