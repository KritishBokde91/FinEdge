import 'dart:io';
import '../../../../core/constants/app_constants.dart';

/// Complete backup DTO wrapper containing metadata, database records, and settings preferences.
///
/// Ported from BackupModels.kt.
class BackupPayload {
  final String warning;
  final String created;
  final BackupMetadata metadata;
  final DatabaseSnapshot database;
  final PreferencesSnapshot preferences;

  const BackupPayload({
    this.warning = 'Contains sensitive financial data. Keep this file secure.',
    required this.created,
    required this.metadata,
    required this.database,
    required this.preferences,
  });

  Map<String, dynamic> toJson() => {
        'warning': warning,
        '_created': created,
        'metadata': metadata.toJson(),
        'database': database.toJson(),
        'preferences': preferences.toJson(),
      };

  factory BackupPayload.fromJson(Map<String, dynamic> json) => BackupPayload(
        warning: json['warning'] as String? ?? '',
        created: json['_created'] as String? ?? '',
        metadata: BackupMetadata.fromJson(
            json['metadata'] as Map<String, dynamic>? ?? const {}),
        database: DatabaseSnapshot.fromJson(
            json['database'] as Map<String, dynamic>? ?? const {}),
        preferences: PreferencesSnapshot.fromJson(
            json['preferences'] as Map<String, dynamic>? ?? const {}),
      );
}

/// Metadata about the backup generation context.
class BackupMetadata {
  final String exportId;
  final String appVersion;
  final int databaseVersion;
  final String device;
  final int androidVersion;

  const BackupMetadata({
    this.exportId = '',
    this.appVersion = '1.0.0',
    this.databaseVersion = AppConstants.databaseVersion,
    this.device = 'Android / iOS',
    this.androidVersion = 0,
  });

  Map<String, dynamic> toJson() => {
        'export_id': exportId,
        'app_version': appVersion,
        'database_version': databaseVersion,
        'device': device,
        'android_version': androidVersion,
      };

  factory BackupMetadata.fromJson(Map<String, dynamic> json) => BackupMetadata(
        exportId: json['export_id'] as String? ?? '',
        appVersion: json['app_version'] as String? ?? '1.0.0',
        databaseVersion:
            json['database_version'] as int? ?? AppConstants.databaseVersion,
        device: json['device'] as String? ?? 'Android / iOS',
        androidVersion: json['android_version'] as int? ?? 0,
      );
}

/// Snapshot of the SQLite Drift database tables.
class DatabaseSnapshot {
  final List<Map<String, dynamic>> smsMetadata;
  final List<Map<String, dynamic>> transactions;
  final List<Map<String, dynamic>> budgets;
  final List<Map<String, dynamic>> subscriptions;
  final List<Map<String, dynamic>> goals;
  final List<Map<String, dynamic>> notifications;
  final List<Map<String, dynamic>> fraudAlerts;
  final List<Map<String, dynamic>> aiInsights;
  final List<Map<String, dynamic>> rules;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> cards;
  final List<Map<String, dynamic>> merchantMappings;

  const DatabaseSnapshot({
    this.smsMetadata = const [],
    this.transactions = const [],
    this.budgets = const [],
    this.subscriptions = const [],
    this.goals = const [],
    this.notifications = const [],
    this.fraudAlerts = const [],
    this.aiInsights = const [],
    this.rules = const [],
    this.categories = const [],
    this.cards = const [],
    this.merchantMappings = const [],
  });

  Map<String, dynamic> toJson() => {
        'sms_metadata': smsMetadata,
        'transactions': transactions,
        'budgets': budgets,
        'subscriptions': subscriptions,
        'goals': goals,
        'notifications': notifications,
        'fraud_alerts': fraudAlerts,
        'ai_insights': aiInsights,
        'rules': rules,
        'categories': categories,
        'cards': cards,
        'merchant_mappings': merchantMappings,
      };

  factory DatabaseSnapshot.fromJson(Map<String, dynamic> json) =>
      DatabaseSnapshot(
        smsMetadata: _parseList(json['sms_metadata']),
        transactions: _parseList(json['transactions']),
        budgets: _parseList(json['budgets']),
        subscriptions: _parseList(json['subscriptions']),
        goals: _parseList(json['goals']),
        notifications: _parseList(json['notifications']),
        fraudAlerts: _parseList(json['fraud_alerts']),
        aiInsights: _parseList(json['ai_insights']),
        rules: _parseList(json['rules']),
        categories: _parseList(json['categories']),
        cards: _parseList(json['cards']),
        merchantMappings: _parseList(json['merchant_mappings']),
      );

  static List<Map<String, dynamic>> _parseList(dynamic source) {
    if (source is List) {
      return source.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return const [];
  }
}

/// User settings preferences snapshot.
class PreferencesSnapshot {
  final String? themeMode;
  final bool? biometricEnabled;
  final int? lastSmsSyncTimestamp;

  const PreferencesSnapshot({
    this.themeMode,
    this.biometricEnabled,
    this.lastSmsSyncTimestamp,
  });

  Map<String, dynamic> toJson() => {
        'theme_mode': themeMode,
        'biometric_enabled': biometricEnabled,
        'last_sms_sync_timestamp': lastSmsSyncTimestamp,
      };

  factory PreferencesSnapshot.fromJson(Map<String, dynamic> json) =>
      PreferencesSnapshot(
        themeMode: json['theme_mode'] as String?,
        biometricEnabled: json['biometric_enabled'] as bool?,
        lastSmsSyncTimestamp: json['last_sms_sync_timestamp'] as int?,
      );
}

/// Outcome of database restore operation.
sealed class ImportResult {
  const ImportResult();
}

class ImportSuccess extends ImportResult {
  final int importedTransactions;
  final int importedBudgets;
  final int importedGoals;
  final int importedSubscriptions;
  final int skippedDuplicates;

  const ImportSuccess({
    required this.importedTransactions,
    required this.importedBudgets,
    required this.importedGoals,
    required this.importedSubscriptions,
    required this.skippedDuplicates,
  });
}

class ImportError extends ImportResult {
  final String message;
  const ImportError(this.message);
}

/// Outcome of database backup operation.
sealed class ExportResult {
  const ExportResult();
}

class ExportSuccess extends ExportResult {
  final File file;
  const ExportSuccess(this.file);
}

class ExportError extends ExportResult {
  final String message;
  const ExportError(this.message);
}
