/// Free-tier quotas for premium-gated features in FinSight.
///
/// Ported from FreeTierLimits.kt. Feature modules read these limits and
/// combine them with premium status check to decide if upgrade dialogs
/// need to be shown.
abstract class FreeTierLimits {
  /// Max rules a free user can create. Pro = unlimited.
  static const int maxRules = 3;

  /// Max statements (e.g. PDF statement imports) per calendar month. Pro = unlimited.
  static const int maxStatementImportsPerMonth = 1;

  /// Max rows a free user can export to CSV format per calendar month. Pro = unlimited.
  static const int maxCsvExportRowsPerMonth = 100;
}
