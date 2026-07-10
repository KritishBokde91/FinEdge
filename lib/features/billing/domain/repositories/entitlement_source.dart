import '../entities/pro_product.dart';

/// Read-only view of billing state. Gated features read from this.
///
/// Ported from EntitlementSource.kt.
abstract class EntitlementSource {
  /// Stream of premium entitlement updates.
  Stream<bool> watchIsPro();

  /// Synchronous snapshot of the current premium status.
  bool get currentIsPro;

  /// Stream of localized product catalog available on the paywall.
  Stream<List<ProProduct>> watchProducts();

  /// Synchronous snapshot of current product catalog.
  List<ProProduct> get currentProducts;
}
