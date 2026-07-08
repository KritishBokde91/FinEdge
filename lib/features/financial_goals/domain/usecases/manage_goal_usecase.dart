import 'package:uuid/uuid.dart';
import '../../../../core/error/result.dart';
import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

/// Progress snapshot for a single goal.
class GoalProgress {
  final GoalEntity goal;
  final double progressRatio; // 0.0 to 1.0+
  final double remainingAmount;
  final int? daysRemaining; // null if no target date
  final bool isCompleted;

  const GoalProgress({
    required this.goal,
    required this.progressRatio,
    required this.remainingAmount,
    required this.daysRemaining,
    required this.isCompleted,
  });
}

/// Manages financial goals: CRUD + progress computation.
///
/// Ported from PennyWise's goal management concepts: create/update/delete goals
/// and calculate percentage progress, days remaining, and completion status.
class ManageGoalUseCase {
  final GoalRepository _repository;
  static const _uuid = Uuid();

  const ManageGoalUseCase(this._repository);

  /// Creates a new financial goal.
  Future<Result<void>> createGoal({
    required String title,
    required double targetAmount,
    required double currentAmount,
    required DateTime targetDate,
    required String category,
  }) async {
    final goal = GoalEntity(
      id: _uuid.v4(),
      title: title.trim(),
      targetAmount: targetAmount,
      currentAmount: currentAmount.clamp(0, double.infinity),
      targetDate: targetDate,
      category: category.trim(),
    );
    return _repository.insertGoal(goal);
  }

  /// Updates progress on an existing goal (adds [addedAmount] to current).
  Future<Result<void>> updateGoalProgress(
    GoalEntity goal,
    double addedAmount,
  ) {
    final updated = GoalEntity(
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      currentAmount: (goal.currentAmount + addedAmount).clamp(
        0,
        double.infinity,
      ),
      targetDate: goal.targetDate,
      category: goal.category,
    );
    return _repository.updateGoal(updated);
  }

  /// Fully replaces a goal entity (for editing all fields).
  Future<Result<void>> updateGoal(GoalEntity goal) {
    return _repository.updateGoal(goal);
  }

  /// Deletes a goal by ID.
  Future<Result<void>> deleteGoal(String id) {
    return _repository.deleteGoal(id);
  }

  /// Watches all goals reactively.
  Stream<List<GoalEntity>> watchGoals() {
    return _repository.watchAllGoals();
  }

  /// Computes progress metadata for a single goal.
  GoalProgress computeProgress(GoalEntity goal) {
    final ratio = goal.targetAmount > 0
        ? goal.currentAmount / goal.targetAmount
        : 0.0;
    final remaining = (goal.targetAmount - goal.currentAmount).clamp(
      0.0,
      double.infinity,
    ).toDouble();

    final now = DateTime.now();
    final daysRemaining = goal.targetDate.isAfter(now)
        ? goal.targetDate.difference(now).inDays
        : null;

    return GoalProgress(
      goal: goal,
      progressRatio: ratio.clamp(0.0, 2.0).toDouble(), // cap display at 200%
      remainingAmount: remaining,
      daysRemaining: daysRemaining,
      isCompleted: goal.currentAmount >= goal.targetAmount,
    );
  }
}
