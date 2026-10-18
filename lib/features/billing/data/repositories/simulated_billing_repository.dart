import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/pro_product.dart';
import '../../domain/entities/purchase_result.dart';
import '../../domain/repositories/purchase_gateway.dart';

/// Concrete implementation of [PurchaseGateway] that simulates Billing operations.
///
/// Ported from PlayBillingGateway/FdroidBillingGateway logic, adapted for Flutter
/// environments using [SharedPreferences] to persist state between runs.
class SimulatedBillingRepository implements PurchaseGateway {
  final SharedPreferences _prefs;
  static const String _keyIsPro = 'billing_pro_entitled';

  final _isProController = StreamController<bool>.broadcast();
  final _productsController = StreamController<List<ProProduct>>.broadcast();

  bool _isPro = false;
  final List<ProProduct> _products = [];

  SimulatedBillingRepository(this._prefs) {
    // Read cached state
    _isPro = _prefs.getBool(_keyIsPro) ?? false;
    _isProController.add(_isPro);

    // Initialize mock product catalog (matches ProSku structure in PlayBillingGateway)
    _products.addAll([
      const ProProduct(
        sku: ProSku.subscription,
        basePlanId: ProSku.basePlanMonthly,
        type: ProductType.subscriptionMonthly,
        priceFormatted: '₹99/month',
        priceMicros: 99000000,
        currencyCode: 'INR',
      ),
      const ProProduct(
        sku: ProSku.subscription,
        basePlanId: ProSku.basePlanAnnual,
        type: ProductType.subscriptionAnnual,
        priceFormatted: '₹799/year',
        priceMicros: 799000000,
        originalPriceFormatted: '₹1,188/year',
        originalPriceMicros: 1188000000,
        currencyCode: 'INR',
      ),
      const ProProduct(
        sku: ProSku.lifetime,
        type: ProductType.lifetime,
        priceFormatted: '₹1,999',
        priceMicros: 1999000000,
        originalPriceFormatted: '₹2,999',
        originalPriceMicros: 2999000000,
        currencyCode: 'INR',
      ),
    ]);
    _productsController.add(_products);
  }

  @override
  bool get currentIsPro => _isPro;

  @override
  List<ProProduct> get currentProducts => _products;

  @override
  Stream<bool> watchIsPro() async* {
    yield _isPro;
    yield* _isProController.stream;
  }

  @override
  Stream<List<ProProduct>> watchProducts() async* {
    yield _products;
    yield* _productsController.stream;
  }

  @override
  Future<PurchaseResult> launchPurchase(ProProduct product) async {
    // Simulate network latency / store purchase sheet animation delay
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    try {
      _isPro = true;
      await _prefs.setBool(_keyIsPro, true);
      _isProController.add(true);
      return const PurchaseSuccess();
    } catch (e) {
      return PurchaseFailed(
        code: -1,
        debugMessage: 'Store helper transaction write failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<PurchaseResult> refresh() async {
    // Simulate query delay
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    try {
      _isPro = _prefs.getBool(_keyIsPro) ?? false;
      _isProController.add(_isPro);
      return const PurchaseSuccess();
    } catch (e) {
      return PurchaseServiceUnavailable(
        code: -2,
        debugMessage: 'Store connection timeout: ${e.toString()}',
      );
    }
  }

  /// Helper to manually reset/revoke Pro entitlement (useful for testing or debugging)
  Future<void> debugResetEntitlement() async {
    _isPro = false;
    await _prefs.setBool(_keyIsPro, false);
    _isProController.add(false);
  }

  /// Closes active broadcast controllers.
  void dispose() {
    _isProController.close();
    _productsController.close();
  }
}
