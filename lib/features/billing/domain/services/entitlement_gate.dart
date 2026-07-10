import '../repositories/entitlement_source.dart';

/// Single source of truth feature gate that premium features check.
///
/// Ported from EntitlementGate.kt. Decouples premium gate checks from the
/// actual billing gateway or specific store backend implementations.
class EntitlementGate {
  final EntitlementSource _entitlementSource;

  const EntitlementGate(this._entitlementSource);

  /// Reactive stream of premium entitlement state.
  Stream<bool> get isProEntitledStream => _entitlementSource.watchIsPro();

  /// Synchronous snapshot of the current entitlement gate state.
  bool get isProEntitled => _entitlementSource.currentIsPro;
}
