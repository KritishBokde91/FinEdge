import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/logger/app_logger.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';

extension on BudgetsTableData {
  BudgetEntity toEntity() {
    return BudgetEntity(
      id: id,
      category: category,
      limitAmount: limitAmount,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

extension on BudgetEntity {
  BudgetsTableCompanion toCompanion() {
    return BudgetsTableCompanion(
      id: Value(id),
      category: Value(category),
      limitAmount: Value(limitAmount),
      startDate: Value(startDate),
      endDate: Value(endDate),
    );
  }
}

class BudgetRepositoryImpl implements BudgetRepository {
  final AppDatabase _db;

  const BudgetRepositoryImpl(this._db);

  @override
  Stream<List<BudgetEntity>> watchAllBudgets() {
    return (_db.select(_db.budgetsTable)..orderBy([
          (t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc),
        ]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<Result<void>> insertBudget(BudgetEntity budget) async {
    try {
      await _db
          .into(_db.budgetsTable)
          .insert(budget.toCompanion(), mode: InsertMode.insertOrReplace);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to insert budget limit', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteBudget(String id) async {
    try {
      final query = _db.delete(_db.budgetsTable)..where((t) => t.id.equals(id));
      await query.go();
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to delete budget limit', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
