import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finsight_ai/features/billing/data/repositories/simulated_billing_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late SimulatedBillingRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'billing_pro_entitled': false});
    prefs = await SharedPreferences.getInstance();
    repository = SimulatedBillingRepository(prefs);
  });

  tearDown(() {
    repository.dispose();
  });

  group('SimulatedBillingRepository lifecycle and stream tests', () {
    test('initial state reads from SharedPreferences correctly', () {
      expect(repository.currentIsPro, isFalse);
      expect(repository.currentProducts, isNotEmpty);
      expect(repository.currentProducts.length, 3);
    });

    test('watchIsPro yields current and updated states', () async {
      final expectation = expectLater(
        repository.watchIsPro(),
        emitsInOrder([false, true]),
      );

      final product = repository.currentProducts.first;
      await repository.launchPurchase(product);
      expect(repository.currentIsPro, isTrue);

      await expectation;
    });

    test('debugResetEntitlement revokes Pro status and emits update', () async {
      final expectation = expectLater(
        repository.watchIsPro(),
        emitsInOrder([false, true, false]),
      );

      final product = repository.currentProducts.first;
      await repository.launchPurchase(product);
      expect(repository.currentIsPro, isTrue);

      await repository.debugResetEntitlement();
      expect(repository.currentIsPro, isFalse);

      await expectation;
    });

    test('dispose closes stream controllers without throw', () {
      final repo = SimulatedBillingRepository(prefs);
      expect(() => repo.dispose(), returnsNormally);
    });
  });
}
