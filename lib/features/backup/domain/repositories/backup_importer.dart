import '../entities/backup_models.dart';

/// Contract representing read-side operations to parse and restore database state.
///
/// Ported from BackupImporter.kt.
abstract class BackupImporter {
  /// Validates compatibility and imports/merges tables snapshot into local database.
  Future<ImportResult> importBackup(String jsonContent);
}
