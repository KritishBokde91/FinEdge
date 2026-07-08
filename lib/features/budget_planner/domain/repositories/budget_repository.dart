import '../../../../core/error/result.dart';
import '../entities/budget_entity.dart';

/// Repository interface (contract) outlining operations for budgeting.
abstract class BudgetRepository {
  /// Watches all budgets reactively
  Stream<List<BudgetEntity>> watchAllBudgets();

  /// Saves a budget limit
  Future<Result<void>> insertBudget(BudgetEntity budget);

  /// Deletes a budget target
  Future<Result<void>> deleteBudget(String id);
}
