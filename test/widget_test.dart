import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:finsight_ai/main.dart';
import 'package:finsight_ai/core/database/database_provider.dart';
import 'package:finsight_ai/core/database/drift_database.dart';
import 'package:finsight_ai/features/splash/presentation/pages/splash_page.dart';

void main() {
  setUp(() {
    // Seed lightweight key values for onboarding flow testing
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': false,
      'initial_setup_completed': false,
    });
  });

  testWidgets('App startup initialization, Splash rendering, and Onboarding redirection smoke test', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Use high-performance in-memory database connection for isolated testing environment
    final testDb = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          databaseProvider.overrideWithValue(testDb),
        ],
        child: const MyApp(),
      ),
    );

    // 1. Verify SplashPage renders initially with the application title
    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('FinSight'), findsOneWidget);

    // 2. Wait for Splash animation and onboarding check initialization delay
    await tester.pumpAndSettle(const Duration(milliseconds: 2500));

    // 3. Verify it routes to onboarding view since onboarding_completed preference was set to false
    expect(find.text('On-Device Financial SMS Intelligence'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
