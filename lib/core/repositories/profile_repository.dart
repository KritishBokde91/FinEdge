import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing multi-profile configurations.
///
/// Ported from ProfileRepository.kt.
class ProfileRepository {
  final ProfileDao _dao;

  const ProfileRepository(this._dao);

  Future<int> insertProfile(ProfilesTableCompanion entry) => _dao.insertProfile(entry);

  Future<List<ProfilesTableData>> getProfiles() => _dao.getAllProfiles();
}
