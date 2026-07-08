import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connection/native.dart';
import 'drift_database.dart';

/// Provider for the single reactive instance of AppDatabase.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(openConnection());
  ref.onDispose(() => db.close());
  return db;
});
