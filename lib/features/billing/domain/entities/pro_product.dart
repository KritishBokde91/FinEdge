enum ProductType {
  subscriptionMonthly,
  subscriptionAnnual,
  lifetime,
}

/// UI-facing model for a single purchasable "plan."
///
/// Ported from ProProduct.kt: translated from Android Billing client types so
/// that the presentation layer is decoupled from underlying store details.
class ProProduct {
  final String sku;
  final String? basePlanId;
  final ProductType type;
  final String priceFormatted;
  final int priceMicros;
  final String? originalPriceFormatted;
  final int? originalPriceMicros;
  final String currencyCode;
  final String? offerToken;

  const ProProduct({
    required this.sku,
    this.basePlanId,
    required this.type,
    required this.priceFormatted,
    required this.priceMicros,
    this.originalPriceFormatted,
    this.originalPriceMicros,
    required this.currencyCode,
    this.offerToken,
  });

  /// Stable unique key for UI selection state — distinguishes base plans within a subscription.
  String get key => basePlanId != null ? '$sku#$basePlanId' : sku;

  /// Convenience: true when a Discount offer is actively reducing this product's price.
  bool get isDiscounted =>
      originalPriceMicros != null && originalPriceMicros! > priceMicros;
}

/// Play Console / App Store product IDs.
///
/// Ported from ProSku object in ProProduct.kt.
abstract class ProSku {
  static const String lifetime = 'pro_lifetime';
  static const String subscription = 'pro_subscription';
  static const String basePlanMonthly = 'monthly';
  static const String basePlanAnnual = 'annual';

  static const List<String> subscriptions = [subscription];
  static const List<String> oneTime = [lifetime];
  static const List<String> all = [subscription, lifetime];
}
