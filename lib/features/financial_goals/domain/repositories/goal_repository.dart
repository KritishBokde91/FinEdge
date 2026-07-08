import '../../../../core/error/result.dart';
import '../entities/goal_entity.dart';

abstract class GoalRepository {
  Stream<List<GoalEntity>> watchAllGoals();
  Future<Result<void>> insertGoal(GoalEntity goal);
  Future<Result<void>> updateGoal(GoalEntity goal);
  Future<Result<void>> deleteGoal(String id);
}
