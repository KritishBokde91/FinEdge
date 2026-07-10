import 'entitlement_source.dart';
import 'purchase_launcher.dart';

/// Unified billing gateway representing the complete read/write surface.
///
/// Ported from PurchaseGateway.kt.
abstract class PurchaseGateway implements EntitlementSource, PurchaseLauncher {}
