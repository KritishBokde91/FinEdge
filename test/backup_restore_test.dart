import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finsight_ai/core/database/drift_database.dart';
import 'package:finsight_ai/core/services/preferences_service.dart';
import 'package:finsight_ai/core/constants/app_constants.dart';
import 'package:finsight_ai/features/backup/data/repositories/drift_backup_repository.dart';
import 'package:finsight_ai/features/backup/domain/entities/backup_models.dart';

void main() {
  late AppDatabase db;
  late PreferencesService prefsService;
  late DriftBackupRepository backupRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({
      'theme_mode': 'dark',
      'biometric_enabled': true,
      'last_sms_sync_timestamp': 1710000000000,
    });
    final sharedPrefs = await SharedPreferences.getInstance();
    prefsService = PreferencesService(sharedPrefs);
    backupRepo = DriftBackupRepository(db, prefsService);
  });

  tearDown(() async {
    await db.close();
  });

  test('BackupMetadata defaults to AppConstants.databaseVersion', () {
    const meta = BackupMetadata();
    expect(meta.databaseVersion, equals(AppConstants.databaseVersion));
    expect(meta.databaseVersion, equals(6));
  });

  test('DatabaseSnapshot serializes and deserializes all tables including rules, categories, cards', () {
    const snapshot = DatabaseSnapshot(
      transactions: [
        {'id': 'tx_1', 'amount': 100.0, 'merchant': 'Uber', 'category': 'Transport'}
      ],
      budgets: [
        {'id': 'b_1', 'category': 'Transport', 'limitAmount': 5000.0}
      ],
      rules: [
        {'id': 'r_1', 'name': 'Uber to Transport', 'priority': 100}
      ],
      categories: [
        {'id': 1, 'name': 'Custom Cat', 'isIncome': false}
      ],
      cards: [
        {'id': 1, 'bankName': 'HDFC', 'cardLast4': '1234', 'cardType': 'CREDIT'}
      ],
      merchantMappings: [
        {'id': 1, 'rawMerchant': 'UBER*TRIP', 'cleanMerchant': 'Uber'}
      ],
    );

    final jsonMap = snapshot.toJson();
    final reconstructed = DatabaseSnapshot.fromJson(jsonMap);

    expect(reconstructed.transactions.length, equals(1));
    expect(reconstructed.budgets.length, equals(1));
    expect(reconstructed.rules.length, equals(1));
    expect(reconstructed.categories.length, equals(1));
    expect(reconstructed.cards.length, equals(1));
    expect(reconstructed.merchantMappings.length, equals(1));
    expect(reconstructed.rules.first['name'], equals('Uber to Transport'));
  });

  test('importBackup rejects payloads with higher databaseVersion', () async {
    final payload = <String, dynamic>{
      '_created': DateTime.now().toIso8601String(),
      'metadata': {
        'export_id': 'test',
        'app_version': '2.0.0',
        'database_version': 99,
      },
      'database': <String, dynamic>{},
      'preferences': <String, dynamic>{},
    };

    final result = await backupRepo.importBackup(json.encode(payload));
    expect(result, isA<ImportError>());
    final error = result as ImportError;
    expect(error.message, contains('is not compatible with local version'));
  });
}
