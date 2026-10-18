import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/drift_database.dart';
import '../database/database_provider.dart';
import 'supabase_client_provider.dart';
import '../../features/transactions/domain/entities/transaction_entity.dart';

/// Syncs on-device transaction data to the user's Supabase account.
///
/// Design principles:
/// - **Local-first**: sync only happens if the user is signed in.
/// - **Idempotent**: uses `upsert` with the transaction `id` as PK, so
///   re-syncing never creates duplicates.
/// - **Incremental**: [syncNewTransaction] is called for each new SMS parse.
/// - **Historical**: [syncAllLocalTransactions] is called once on sign-in to
///   push every existing local transaction to the cloud.
class SupabaseSyncService {
  final SupabaseClient supabaseClient;
  final AppDatabase appDatabase;

  static const String _tag = 'SupabaseSyncService';
  static const String _table = 'transactions';

  const SupabaseSyncService({
    required this.supabaseClient,
    required this.appDatabase,
  });

  // ────────────────────────────────────────────────────────────────────────
  // Public API
  // ────────────────────────────────────────────────────────────────────────

  /// Upserts a single transaction that was just parsed from an SMS.
  ///
  /// Safe to call for every new transaction — no-ops if not signed in.
  Future<void> syncNewTransaction(TransactionEntity tx) async {
    final userId = _currentUserId;
    if (userId == null) return; // offline / not signed in

    try {
      await supabaseClient.from(_table).upsert(
        _toRow(tx, userId),
        onConflict: 'id',
      );
      developer.log('Synced new transaction ${tx.id}', name: _tag);
    } catch (e, stack) {
      developer.log(
        'Failed to sync transaction ${tx.id}: $e',
        name: _tag,
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Pushes every transaction in the local SQLite DB to Supabase.
  ///
  /// Called once after successful sign-in. Batches rows in groups of 200
  /// to stay within Supabase request limits. Already-synced rows are safely
  /// overwritten in-place (upsert), so it is always safe to call again.
  Future<void> syncAllLocalTransactions() async {
    final userId = _currentUserId;
    if (userId == null) return;

    try {
      final rows =
          await appDatabase.select(appDatabase.transactionsTable).get();
      if (rows.isEmpty) {
        developer.log('No local transactions to sync', name: _tag);
        return;
      }

      developer.log(
        'Starting historical sync of ${rows.length} transactions',
        name: _tag,
      );

      const batchSize = 200;
      int synced = 0;

      for (var i = 0; i < rows.length; i += batchSize) {
        final batch = rows.skip(i).take(batchSize).toList();
        final payload =
            batch.map((row) => _toRow(_rowToEntity(row), userId)).toList();

        await supabaseClient.from(_table).upsert(payload, onConflict: 'id');
        synced += batch.length;
        developer.log(
          'Synced $synced/${rows.length} transactions',
          name: _tag,
        );
      }

      developer.log(
        'Historical sync complete: $synced transactions',
        name: _tag,
      );
    } catch (e, stack) {
      developer.log(
        'Historical sync failed: $e',
        name: _tag,
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ────────────────────────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────────────────────────

  String? get _currentUserId => supabaseClient.auth.currentUser?.id;

  /// Maps a [TransactionEntity] to a Supabase row map.
  Map<String, dynamic> _toRow(TransactionEntity tx, String userId) {
    return {
      'id': tx.id,
      'user_id': userId,
      'amount': tx.amount,
      'merchant': tx.merchant,
      'category': tx.category,
      'is_income': tx.isIncome,
      'account_source': tx.accountSource,
      'reference': tx.reference,
      'currency': tx.currency,
      'sms_id': tx.smsId,
      'sms_hash': tx.id, // dedup key mirrors the local PK
      'date': tx.timestamp.toUtc().toIso8601String(),
      'synced_at': DateTime.now().toUtc().toIso8601String(),
    };
  }

  TransactionEntity _rowToEntity(TransactionsTableData row) {
    return TransactionEntity(
      id: row.id,
      smsId: row.smsId,
      amount: row.amount,
      merchant: row.merchant,
      category: row.category,
      timestamp: row.timestamp,
      isIncome: row.isIncome,
      accountSource: row.accountSource,
      reference: row.reference,
      currency: row.currency,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Riverpod provider
// ──────────────────────────────────────────────────────────────────────────

/// Provides the [SupabaseSyncService] singleton.
final supabaseSyncServiceProvider = Provider<SupabaseSyncService>((ref) {
  return SupabaseSyncService(
    supabaseClient: ref.watch(supabaseClientProvider),
    appDatabase: ref.watch(databaseProvider),
  );
});
