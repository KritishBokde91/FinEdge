/// Common interface for mandate (subscription / auto-debit) information
/// across all banks.
///
/// Direct port of `parser-core/MandateInfo.kt`.
/// Field names and semantics are preserved verbatim.
abstract class MandateInfo {
  /// The amount that will be charged.
  double get amount;

  /// The next deduction date in string format.
  /// Date format varies by bank (e.g., "dd/MM/yy", "d-MMM-yy").
  String? get nextDeductionDate;

  /// The merchant / service name.
  String get merchant;

  /// Unique Mandate Number (if available).
  /// May be null for some banks or mandate types.
  String? get umn;

  /// The date format used by this bank for parsing [nextDeductionDate].
  /// Default is "dd/MM/yy" but can be overridden per bank.
  String get dateFormat => 'dd/MM/yy';
}
