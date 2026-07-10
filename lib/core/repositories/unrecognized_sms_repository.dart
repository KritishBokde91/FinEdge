import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing failed SMS parse caches.
///
/// Ported from UnrecognizedSmsRepository.kt.
class UnrecognizedSmsRepository {
  final UnrecognizedSmsDao _dao;

  const UnrecognizedSmsRepository(this._dao);

  Future<int> insertUnrecognized(UnrecognizedSmsTableCompanion entry) => _dao.insertUnrecognized(entry);

  Future<List<UnrecognizedSmsTableData>> getUnrecognized() => _dao.getAllUnrecognized();
}
