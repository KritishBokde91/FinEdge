/// Outcome of a billing operation (refresh, restore, or purchase launcher).
///
/// Ported from PurchaseResult.kt. Sealed-style structure to force callers to
/// handle every case explicitly.
sealed class PurchaseResult {
  const PurchaseResult();
}

/// Operation succeeded. Entitlement state has been refreshed downstream.
class PurchaseSuccess extends PurchaseResult {
  const PurchaseSuccess();
}

/// User cancelled the purchase sheet. Not an error.
class PurchaseUserCancelled extends PurchaseResult {
  const PurchaseUserCancelled();
}

/// Purchase is awaiting an out-of-band payment method (UPI collect, cash, etc.).
class PurchasePending extends PurchaseResult {
  const PurchasePending();
}

/// Billing service couldn't connect, network down, or store app out-of-date.
class PurchaseServiceUnavailable extends PurchaseResult {
  final int code;
  final String? debugMessage;
  const PurchaseServiceUnavailable({required this.code, this.debugMessage});
}

/// Generic billing failure (developer error, item unavailable, etc.).
class PurchaseFailed extends PurchaseResult {
  final int code;
  final String? debugMessage;
  const PurchaseFailed({required this.code, this.debugMessage});
}

/// Billing isn't available in this build (e.g. mock or alternative flavor).
class PurchaseUnsupported extends PurchaseResult {
  const PurchaseUnsupported();
}
