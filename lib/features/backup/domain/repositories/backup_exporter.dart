import '../entities/backup_models.dart';

/// Contract representing write-side operations to serialize and write database state.
///
/// Ported from BackupExporter.kt.
abstract class BackupExporter {
  /// Exports active database records and preferences as a secure backup JSON file.
  Future<ExportResult> exportBackup();
}
