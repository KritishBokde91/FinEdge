import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/repository_providers.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/supabase/supabase_sync_service.dart';
import '../../../../main.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../entities/sms_entity.dart';
import '../repositories/sms_repository.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/database/database_provider.dart';
import 'sms_transaction_processor.dart';
import '../entities/parsed_transaction.dart';
import '../../../../core/enums/transaction_type.dart';

class SmsSyncService {
  final SmsRepository smsRepo;
  final TransactionRepository txRepo;
  final PermissionService permissionService;
  final PreferencesService prefs;
  final AppDatabase db;
  final SmsTransactionProcessor smsTransactionProcessor;
  final SupabaseSyncService supabaseSyncService;

  static const _channel = MethodChannel('com.genzloop.finsight_ai/sms');

  SmsSyncService({
    required this.smsRepo,
    required this.txRepo,
    required this.permissionService,
    required this.prefs,
    required this.db,
    required this.smsTransactionProcessor,
    required this.supabaseSyncService,
  });

  /// Syncs SMS inbox, returns count of new transactions imported.
  Future<int> syncInbox({int limit = 2000, bool forceResync = false}) async {
    try {
      // Check permission first
      final hasPermission = await permissionService.checkSmsPermission();
      if (!hasPermission) {
        developer.log('SMS permission not granted', name: 'SmsSyncService');
        return 0;
      }

      // Android only
      if (!Platform.isAndroid) {
        developer.log(
          'Not on Android, skipping SMS sync',
          name: 'SmsSyncService',
        );
        return 0;
      }

      // Get last sync timestamp for incremental sync
      final storedLastSync = prefs.getLastSmsSyncTimestamp();
      final currentTxList = await db.select(db.transactionsTable).get();
      final scanFromStart = forceResync || currentTxList.isEmpty;
      final lastSync = scanFromStart ? 0 : storedLastSync;
      developer.log(
        'Starting SMS sync. Last sync: $lastSync, Limit: $limit, Force: $scanFromStart',
        name: 'SmsSyncService',
      );
      debugPrint(
        '[SmsSyncService] Starting SMS sync. Last sync: $lastSync, Limit: $limit, Force: $scanFromStart',
      );

      // Read SMS from native inbox
      final List<dynamic>? rawMessages = await _channel.invokeMethod(
        'readSms',
        {'limit': limit, 'since': lastSync},
      );

      if (rawMessages == null || rawMessages.isEmpty) {
        developer.log(
          'No SMS messages returned from inbox',
          name: 'SmsSyncService',
        );
        debugPrint('[SmsSyncService] No SMS messages returned from inbox');
        return 0;
      }

      developer.log(
        'Received ${rawMessages.length} raw SMS from inbox',
        name: 'SmsSyncService',
      );
      debugPrint(
        '[SmsSyncService] Received ${rawMessages.length} raw SMS from inbox',
      );

      int importedCount = 0;
      int maxTimestamp = lastSync;

      for (final raw in rawMessages) {
        try {
          final map = Map<String, dynamic>.from(raw as Map);
          final String smsId = map['id']?.toString() ?? '';
          final String sender = map['address']?.toString() ?? '';
          final String body = map['body']?.toString() ?? '';
          final int dateMs = map['date'] is int ? map['date'] as int : 0;

          if (smsId.isEmpty || body.isEmpty) continue;

          // Track max timestamp for incremental sync
          if (dateMs > maxTimestamp) maxTimestamp = dateMs;

          // Save SMS metadata
          final smsEntity = SmsEntity(
            id: smsId,
            sender: sender,
            body: body,
            timestamp: DateTime.fromMillisecondsSinceEpoch(dateMs),
            isProcessed: true,
            confidence: 1.0,
          );
          await smsRepo.insertSms(smsEntity);

          final nativeParsed = _stringMap(map['parsed']);
          final ProcessingResult result;

          if (nativeParsed != null) {
            final parsed = _mapNativeToParsed(
              nativeParsed,
              sender: sender,
              body: body,
              timestamp: dateMs,
            );
            if (parsed != null) {
              result = await smsTransactionProcessor.saveParsedTransaction(
                parsed,
                body,
                smsId: smsId,
              );
            } else {
              result = const ProcessingResult(
                false,
                reason: 'Failed to map native parsed data',
              );
            }
          } else {
            result = await smsTransactionProcessor.processAndSaveTransaction(
              sender,
              body,
              dateMs,
              smsId: smsId,
            );
          }

          if (result.success) {
            importedCount++;
            // Cloud sync — fire & forget, non-blocking
            if (result.transactionId != null) {
              final txId = result.transactionId!;
              unawaited(
                txRepo.getTransactionById(txId).then((res) {
                  res.fold(
                    (_) {}, // local lookup failed, skip cloud sync
                    (tx) => supabaseSyncService.syncNewTransaction(tx),
                  );
                }),
              );
            }
          }
        } catch (e, stack) {
          developer.log(
            'Error processing SMS: $e',
            name: 'SmsSyncService',
            error: e,
            stackTrace: stack,
          );
          continue;
        }
      }

      // Update last sync timestamp
      if (maxTimestamp > storedLastSync) {
        await prefs.setLastSmsSyncTimestamp(maxTimestamp);
      }

      developer.log(
        'SMS sync complete: $importedCount imported',
        name: 'SmsSyncService',
      );
      debugPrint('[SmsSyncService] SMS sync complete: $importedCount imported');

      return importedCount;
    } catch (e, stack) {
      developer.log(
        'SMS sync failed: $e',
        name: 'SmsSyncService',
        error: e,
        stackTrace: stack,
      );
      return 0;
    }
  }

  ParsedTransaction? _mapNativeToParsed(
    Map<String, String> parsed, {
    required String sender,
    required String body,
    required int timestamp,
  }) {
    final amount = double.tryParse(parsed['amount'] ?? '');
    if (amount == null || amount <= 0) return null;

    final typeStr = parsed['pennywiseType']?.toUpperCase() ?? '';
    final type = TransactionType.values.firstWhere(
      (e) => e.name.toUpperCase() == typeStr,
      orElse: () => TransactionType.expense,
    );

    return ParsedTransaction(
      amount: amount,
      type: type,
      merchant: parsed['merchant'] ?? parsed['bank'] ?? sender,
      reference: parsed['reference'] ?? parsed['referenceNumber'],
      accountLast4: parsed['account'],
      balance: double.tryParse(parsed['balance'] ?? ''),
      creditLimit: double.tryParse(parsed['creditLimit'] ?? ''),
      smsBody: body,
      sender: sender,
      timestamp: timestamp,
      bankName: parsed['bank'] ?? sender,
      transactionHash: parsed['id'],
      isFromCard: parsed['isFromCard']?.toLowerCase() == 'true',
      currency: parsed['currency'] ?? 'INR',
      isMobileWallet: parsed['isMobileWallet']?.toLowerCase() == 'true',
    );
  }
}

Map<String, String>? _stringMap(Object? value) {
  if (value is! Map) return null;
  return value.map((k, v) => MapEntry(k.toString(), v.toString()));
}

/// Riverpod provider exposing the SmsSyncService instance.
final smsSyncServiceProvider = Provider<SmsSyncService>((ref) {
  return SmsSyncService(
    smsRepo: ref.watch(smsRepositoryProvider),
    txRepo: ref.watch(transactionRepositoryProvider),
    permissionService: ref.watch(permissionServiceProvider),
    prefs: ref.watch(preferencesServiceProvider),
    db: ref.watch(databaseProvider),
    smsTransactionProcessor: ref.watch(smsTransactionProcessorProvider),
    supabaseSyncService: ref.watch(supabaseSyncServiceProvider),
  );
});
