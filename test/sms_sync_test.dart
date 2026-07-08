import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:finsight_ai/main.dart';
import 'package:finsight_ai/core/database/database_provider.dart';
import 'package:finsight_ai/core/database/drift_database.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/sms_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'last_sms_sync_timestamp': 0,
    });
  });

  test('SmsSyncService - check initial sync bounds and stubs', () async {
    final prefs = await SharedPreferences.getInstance();
    final testDb = AppDatabase(NativeDatabase.memory());

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(testDb),
      ],
    );

    final syncService = container.read(smsSyncServiceProvider);
    
    // On non-Android environment (test VM), syncInbox returns 0 without calling channel
    final count = await syncService.syncInbox();
    expect(count, 0);
  });
}
