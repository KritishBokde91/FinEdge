import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/backup_models.dart';

/// Cloud backup and restore via Supabase Storage + Postgres.
class SupabaseBackupRepository {
  final SupabaseClient _client;

  const SupabaseBackupRepository(this._client);

  static const _bucketName = 'backups';

  /// Uploads a [BackupPayload] to the user's cloud storage.
  /// Returns the Supabase storage path on success.
  Future<String> uploadBackup(BackupPayload payload) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not signed in to cloud.');

    final jsonStr = jsonEncode(payload.toJson());
    final bytes = utf8.encode(jsonStr);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${user.id}/backup_$timestamp.json';

    await _client.storage.from(_bucketName).uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(
        contentType: 'application/json',
        upsert: false,
      ),
    );

    // Record metadata row in cloud_backups table
    await _client.from('cloud_backups').insert({
      'user_id': user.id,
      'storage_path': path,
      'database_version': payload.metadata.databaseVersion,
      'transaction_count': payload.database.transactions.length,
      'size_bytes': bytes.length,
    });

    return path;
  }

  /// Fetches the latest backup metadata for the current user.
  Future<Map<String, dynamic>?> fetchLatestBackupMeta() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('cloud_backups')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return response;
  }

  /// Downloads and deserializes the latest cloud backup.
  Future<BackupPayload?> downloadLatestBackup() async {
    final meta = await fetchLatestBackupMeta();
    if (meta == null) return null;

    final path = meta['storage_path'] as String;
    final data = await _client.storage.from(_bucketName).download(path);
    final jsonStr = utf8.decode(data);
    return BackupPayload.fromJson(
      jsonDecode(jsonStr) as Map<String, dynamic>,
    );
  }

  /// Lists all cloud backups for the current user, newest first.
  Future<List<Map<String, dynamic>>> listBackups() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('cloud_backups')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Deletes a backup by its storage path.
  Future<void> deleteBackup(String storagePath) async {
    await _client.storage.from(_bucketName).remove([storagePath]);
    await _client
        .from('cloud_backups')
        .delete()
        .eq('storage_path', storagePath);
  }
}
