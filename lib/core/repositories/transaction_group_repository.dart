import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing transaction group records.
///
/// Ported from TransactionGroupRepository.kt.
class TransactionGroupRepository {
  final TransactionGroupDao _dao;

  const TransactionGroupRepository(this._dao);

  Future<int> insertGroup(TransactionGroupsTableCompanion entry) => _dao.insertGroup(entry);

  Future<List<TransactionGroupsTableData>> getGroups() => _dao.getAllGroups();
}
