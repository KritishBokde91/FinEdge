import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../features/billing/data/repositories/simulated_billing_repository.dart';
import '../../features/billing/domain/repositories/purchase_gateway.dart';
import '../../features/billing/domain/services/entitlement_gate.dart';
import '../../features/billing/domain/entities/pro_product.dart';

/// Provider for the simulated billing repository instance.
final purchaseGatewayProvider = Provider<PurchaseGateway>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final repo = SimulatedBillingRepository(prefs);
  ref.onDispose(() => repo.dispose());
  return repo;
});

/// Provider for the single entitlement feature gate.
final entitlementGateProvider = Provider<EntitlementGate>((ref) {
  final gateway = ref.watch(purchaseGatewayProvider);
  return EntitlementGate(gateway);
});

/// Stream of the user's Pro entitlement state.
final isProProvider = StreamProvider<bool>((ref) {
  final gate = ref.watch(entitlementGateProvider);
  return gate.isProEntitledStream;
});

/// Stream of available products to display on the paywall.
final productsProvider = StreamProvider<List<ProProduct>>((ref) {
  final gateway = ref.watch(purchaseGatewayProvider);
  return gateway.watchProducts();
});
