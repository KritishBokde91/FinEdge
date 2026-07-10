import '../../../../core/database/drift_database.dart';

/// Compound model combining a transaction with its splits breakdown.
///
/// Ported from TransactionWithSplits.kt.
class TransactionWithSplits {
  final TransactionsTableData transaction;
  final List<TransactionSplitsTableData> splits;

  const TransactionWithSplits({
    required this.transaction,
    required this.splits,
  });

  /// True if transaction contains splits.
  bool get hasSplits => splits.isNotEmpty;

  /// Returns amount breakdown by category.
  ///
  /// If transaction has splits, returns split amounts.
  /// Otherwise, returns the full transaction amount under its category.
  Map<String, double> getAmountByCategory() {
    if (hasSplits) {
      final breakdown = <String, double>{};
      for (final split in splits) {
        breakdown[split.category] = (breakdown[split.category] ?? 0.0) + split.amount;
      }
      return breakdown;
    } else {
      return {transaction.category: transaction.amount};
    }
  }

  /// Calculates total of all splits.
  double getSplitsTotal() {
    return splits.fold(0.0, (sum, split) => sum + split.amount);
  }

  /// Checks if splits are valid (sum equals transaction amount within tolerance).
  bool areSplitsValid({double tolerance = 0.01}) {
    if (!hasSplits) return true;
    final difference = (transaction.amount - getSplitsTotal()).abs();
    return difference <= tolerance;
  }
}
