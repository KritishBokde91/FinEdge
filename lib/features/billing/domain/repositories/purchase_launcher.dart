import '../entities/pro_product.dart';
import '../entities/purchase_result.dart';

/// Write-side operations for billing/purchasing.
///
/// Ported from PurchaseLauncher.kt. Gated UI elements trigger purchases or
/// restores through this launcher.
abstract class PurchaseLauncher {
  /// Re-queries the store for active entitlements and product options.
  Future<PurchaseResult> refresh();

  /// Launches the purchase sheet/flow for the given [product].
  Future<PurchaseResult> launchPurchase(ProProduct product);
}
