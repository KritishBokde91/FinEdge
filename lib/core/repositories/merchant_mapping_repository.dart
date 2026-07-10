import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing cleaned merchant descriptions mapped from raw SMS strings.
///
/// Ported from MerchantMappingRepository.kt.
class MerchantMappingRepository {
  final MerchantMappingDao _dao;

  const MerchantMappingRepository(this._dao);

  Future<int> insertMapping(MerchantMappingsTableCompanion entry) => _dao.insertMapping(entry);

  Future<MerchantMappingsTableData?> getMappingByRaw(String raw) => _dao.getMappingByRaw(raw);

  Future<String?> getCategoryForMerchant(String merchantName) async {
    final mapping = await getMappingByRaw(merchantName);
    return mapping?.cleanMerchant;
  }

  Future<Map<String, String>> getAllMappingsAsMap() async {
    final all = await _dao.getAllMappings();
    return {for (final m in all) m.rawMerchant: m.cleanMerchant};
  }
}
