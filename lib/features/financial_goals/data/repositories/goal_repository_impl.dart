import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/logger/app_logger.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';

extension on GoalsTableData {
  GoalEntity toEntity() {
    return GoalEntity(
      id: id,
      title: title,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      targetDate: targetDate,
      category: category,
    );
  }
}

extension on GoalEntity {
  GoalsTableCompanion toCompanion() {
    return GoalsTableCompanion(
      id: Value(id),
      title: Value(title),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      targetDate: Value(targetDate),
      category: Value(category),
    );
  }
}

class GoalRepositoryImpl implements GoalRepository {
  final AppDatabase _db;

  const GoalRepositoryImpl(this._db);

  @override
  Stream<List<GoalEntity>> watchAllGoals() {
    return _db.select(_db.goalsTable).watch().map(
          (rows) => rows.map((row) => row.toEntity()).toList(),
        );
  }

  @override
  Future<Result<void>> insertGoal(GoalEntity goal) async {
    try {
      await _db
          .into(_db.goalsTable)
          .insert(goal.toCompanion(), mode: InsertMode.insertOrReplace);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to insert goal', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateGoal(GoalEntity goal) async {
    try {
      await _db.update(_db.goalsTable).replace(goal.toCompanion());
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to update goal', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteGoal(String id) async {
    try {
      final query = _db.delete(_db.goalsTable)..where((t) => t.id.equals(id));
      await query.go();
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to delete goal', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
