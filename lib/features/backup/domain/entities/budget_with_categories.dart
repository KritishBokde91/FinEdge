import '../../../../core/database/drift_database.dart';

/// Compound model combining a budget with its category rules.
///
/// Ported from BudgetWithCategories.kt.
class BudgetWithCategories {
  final BudgetsTableData budget;
  final List<BudgetCategoriesTableData> categories;

  const BudgetWithCategories({
    required this.budget,
    required this.categories,
  });

  /// Total budget amount.
  ///
  /// If the overall budget limit is greater than 0, returns it.
  /// Otherwise, aggregates the category limits.
  double get totalBudgetAmount {
    final overall = budget.limitAmount;
    if (overall > 0) {
      return overall;
    }
    return categories.fold(0.0, (sum, cat) => sum + cat.limitAmount);
  }
}
