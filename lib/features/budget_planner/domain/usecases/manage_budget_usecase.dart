import 'package:uuid/uuid.dart';
import '../../../../core/error/result.dart';
import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

/// Encapsulates budget management operations.
///
/// Ported from PennyWise's [ManageBudgetUseCase.kt]:
///   - Create a budget with category, limit, and date range
///   - Delete a budget by ID
///   - Calculate spending against budget limit for the current period
///   - Get budget utilisation ratio (0.0 to 1.0+)
class ManageBudgetUseCase {
  final BudgetRepository _repository;
  static const _uuid = Uuid();

  const ManageBudgetUseCase(this._repository);

  /// Creates and persists a new budget limit.
  Future<Result<void>> createBudget({
    required String category,
    required double limitAmount,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final budget = BudgetEntity(
      id: _uuid.v4(),
      category: category.trim(),
      limitAmount: limitAmount,
      startDate: startDate,
      endDate: endDate,
    );
    return _repository.insertBudget(budget);
  }

  /// Deletes a budget by its ID.
  Future<Result<void>> deleteBudget(String id) {
    return _repository.deleteBudget(id);
  }

  /// Watches all budgets reactively.
  Stream<List<BudgetEntity>> watchBudgets() {
    return _repository.watchAllBudgets();
  }

  /// Calculate how much has been spent in [category] during a budget period.
  ///
  /// Filters [allTransactions] to those matching the category and falling
  /// within [startDate] to [endDate]. Returns the sum of expenses.
  static double calculateSpending({
    required String category,
    required DateTime startDate,
    required DateTime endDate,
    required List<TransactionEntity> allTransactions,
  }) {
    return allTransactions
        .where((tx) =>
            !tx.isIncome &&
            tx.category == category &&
            !tx.timestamp.isBefore(startDate) &&
            !tx.timestamp.isAfter(endDate))
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Returns a ratio of spending vs limit (0.0 = nothing spent, 1.0 = at limit,
  /// >1.0 = overspent). Mirrors PennyWise's budget utilisation logic.
  static double utilisationRatio({
    required double spent,
    required double limit,
  }) {
    if (limit <= 0) return 0.0;
    return spent / limit;
  }

  /// Determine current active period for monthly budgets.
  /// Returns the start/end of the current calendar month.
  static (DateTime start, DateTime end) currentMonthPeriod() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1)
        .subtract(const Duration(microseconds: 1));
    return (start, end);
  }
}
