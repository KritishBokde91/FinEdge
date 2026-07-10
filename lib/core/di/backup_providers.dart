import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../database/database_provider.dart';
import '../../features/backup/data/repositories/drift_backup_repository.dart';
import '../../features/backup/domain/repositories/backup_exporter.dart';
import '../../features/backup/domain/repositories/backup_importer.dart';

/// Provider for the concrete Drift backup repository instance.
final _backupRepositoryProvider = Provider<DriftBackupRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(preferencesServiceProvider);
  return DriftBackupRepository(db, prefs);
});

/// Exposes the write-side BackupExporter service.
final backupExporterProvider = Provider<BackupExporter>((ref) {
  return ref.watch(_backupRepositoryProvider);
});

/// Exposes the read-side BackupImporter service.
final backupImporterProvider = Provider<BackupImporter>((ref) {
  return ref.watch(_backupRepositoryProvider);
});
