import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing monthly category budget limits.
///
/// Ported from BudgetGroupRepository.kt.
class BudgetGroupRepository {
  final BudgetDao _dao;

  const BudgetGroupRepository(this._dao);

  Future<int> insertBudget(BudgetsTableCompanion entry) => _dao.insertBudget(entry);

  Future<List<BudgetsTableData>> getBudgets() => _dao.getAllBudgets();
}
