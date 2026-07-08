import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/repository_providers.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../main.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../entities/sms_entity.dart';
import '../repositories/sms_repository.dart';
import 'sender_filter.dart';
import 'sms_parser.dart';

class SmsSyncService {
  final SmsRepository smsRepo;
  final TransactionRepository txRepo;
  final PermissionService permissionService;
  final PreferencesService prefs;

  static const _channel = MethodChannel('com.genzloop.finsight_ai/sms');
  static const _uuid = Uuid();

  SmsSyncService({
    required this.smsRepo,
    required this.txRepo,
    required this.permissionService,
    required this.prefs,
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
      final currentTxList = await txRepo.watchAllTransactions().first;
      final force = forceResync || currentTxList.isEmpty;
      if (forceResync) {
        developer.log('Force resync requested: clearing existing database transactions', name: 'SmsSyncService');
        print('[SmsSyncService] Force resync requested: clearing existing database transactions');
        for (final tx in currentTxList) {
          await txRepo.deleteTransaction(tx.id);
        }
      }
      final lastSync = force ? 0 : storedLastSync;
      developer.log(
        'Starting SMS sync. Last sync: $lastSync, Limit: $limit, Force: $force',
        name: 'SmsSyncService',
      );
      print('[SmsSyncService] Starting SMS sync. Last sync: $lastSync, Limit: $limit, Force: $force');

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
        print('[SmsSyncService] No SMS messages returned from inbox');
        return 0;
      }

      developer.log(
        'Received ${rawMessages.length} raw SMS from inbox',
        name: 'SmsSyncService',
      );
      print('[SmsSyncService] Received ${rawMessages.length} raw SMS from inbox');

      int importedCount = 0;
      int filteredBySender = 0;
      int filteredByContent = 0;
      int filteredByParsing = 0;
      int parsedNatively = 0;
      int parsedWithFallback = 0;
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

          final nativeParsed = _stringMap(map['parsed']);
          final _ImportedTransaction? parsedTransaction;

          if (nativeParsed != null) {
            parsedTransaction = _ImportedTransaction.fromNative(
              nativeParsed,
              sender: sender,
              body: body,
            );
            if (parsedTransaction != null) parsedNatively++;
          } else {
            // ── Stage 1: Sender Filter ──
            if (!SenderFilter.isFinancialSender(sender)) {
              filteredBySender++;
              continue;
            }

            // ── Stage 2: Content Filter ──
            if (!SmsParser.isTransactionMessage(body)) {
              filteredByContent++;
              continue;
            }

            // ── Stage 3: Dart fallback parse ──
            final result = SmsParser.parseMessage(sender, body);

            if (result.amount <= 0 || result.transactionType == 'unknown') {
              filteredByParsing++;
              continue;
            }

            // ── Stage 4: Skip failed transactions ──
            if (result.transactionStatus == 'failed') continue;

            parsedTransaction = _ImportedTransaction.fromDart(
              result,
              sender: sender,
            );
            parsedWithFallback++;
          }

          if (parsedTransaction == null || parsedTransaction.amount <= 0) {
            filteredByParsing++;
            continue;
          }

          final timestamp = DateTime.fromMillisecondsSinceEpoch(dateMs);
          final txId =
              parsedTransaction.id ??
              _uuid.v5(
                Uuid.NAMESPACE_URL,
                '$sender|${parsedTransaction.amount}|$dateMs',
              );

          // ── Stage 5: Save SMS metadata ──
          final smsEntity = SmsEntity(
            id: smsId,
            sender: sender,
            body: body,
            timestamp: timestamp,
            isProcessed: true,
            confidence: parsedTransaction.confidence,
          );

          await smsRepo.insertSms(smsEntity);

          // ── Stage 6: Save Transaction ──
          final txEntity = TransactionEntity(
            id: txId,
            smsId: smsId,
            amount: parsedTransaction.amount,
            merchant: parsedTransaction.merchant,
            category: parsedTransaction.category,
            timestamp: timestamp,
            isIncome: parsedTransaction.isIncome,
            accountSource: parsedTransaction.accountSource,
          );

          await txRepo.insertTransaction(txEntity);
          importedCount++;
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
      if (maxTimestamp > storedLastSync && importedCount > 0) {
        await prefs.setLastSmsSyncTimestamp(maxTimestamp);
      }

      developer.log(
        'SMS sync complete: $importedCount imported, '
        '$parsedNatively parsed by PennyWise native bridge, '
        '$parsedWithFallback parsed by Dart fallback, '
        '$filteredBySender filtered by sender, '
        '$filteredByContent filtered by content, '
        '$filteredByParsing filtered by parsing',
        name: 'SmsSyncService',
      );
      print('[SmsSyncService] SMS sync complete: $importedCount imported, '
          '$parsedNatively parsed by PennyWise native bridge, '
          '$parsedWithFallback parsed by Dart fallback, '
          '$filteredBySender filtered by sender, '
          '$filteredByContent filtered by content, '
          '$filteredByParsing filtered by parsing');

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
}

Map<String, dynamic>? _stringMap(Object? value) {
  if (value is! Map) return null;
  return Map<String, dynamic>.from(value);
}

class _ImportedTransaction {
  final String? id;
  final double amount;
  final String merchant;
  final String category;
  final bool isIncome;
  final String accountSource;
  final double confidence;

  const _ImportedTransaction({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.category,
    required this.isIncome,
    required this.accountSource,
    required this.confidence,
  });

  factory _ImportedTransaction.fromDart(
    SmsParseResult result, {
    required String sender,
  }) {
    return _ImportedTransaction(
      id: null,
      amount: result.amount,
      merchant: result.merchant ?? result.bank ?? sender,
      category: result.category,
      isIncome: result.transactionType == 'credit',
      accountSource: result.bank ?? result.account ?? sender,
      confidence: result.confidence,
    );
  }

  static _ImportedTransaction? fromNative(
    Map<String, dynamic> parsed, {
    required String sender,
    required String body,
  }) {
    final amount = _numValue(parsed['amount']);
    if (amount == null || amount <= 0) return null;

    final merchant =
        _stringValue(parsed['merchant']) ??
        _stringValue(parsed['bank']) ??
        sender;
    final pennywiseType = (_stringValue(parsed['pennywiseType']) ?? '')
        .toUpperCase();
    final isIncome = pennywiseType == 'INCOME';

    return _ImportedTransaction(
      id: _stringValue(parsed['id']),
      amount: amount,
      merchant: merchant,
      category: _classifyNativeCategory(
        merchant: merchant,
        body: body,
        pennywiseType: pennywiseType,
      ),
      isIncome: isIncome,
      accountSource:
          _stringValue(parsed['accountSource']) ??
          _stringValue(parsed['bank']) ??
          sender,
      confidence: 1.0,
    );
  }

  static double? _numValue(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String? _stringValue(Object? value) {
    final stringValue = value?.toString().trim();
    if (stringValue == null || stringValue.isEmpty) return null;
    return stringValue;
  }

  static String _classifyNativeCategory({
    required String merchant,
    required String body,
    required String pennywiseType,
  }) {
    final text = '$merchant $body'.toLowerCase();

    if (pennywiseType == 'INCOME') return 'Salary';
    if (pennywiseType == 'INVESTMENT') return 'Investment';
    if (pennywiseType == 'TRANSFER') return 'Transfer';

    if (_containsAny(text, const [
      'swiggy',
      'zomato',
      'restaurant',
      'cafe',
      'food',
      'kfc',
      'mcdonald',
      'domino',
      'pizza',
      'starbucks',
    ])) {
      return 'Food';
    }

    if (_containsAny(text, const [
      'bigbasket',
      'blinkit',
      'zepto',
      'grocery',
      'dmart',
      'jiomart',
      'amazon',
      'flipkart',
      'myntra',
      'nykaa',
      'shopping',
      'store',
      'mart',
    ])) {
      return 'Shopping';
    }

    if (_containsAny(text, const [
      'uber',
      'ola',
      'rapido',
      'irctc',
      'metro',
      'fuel',
      'petrol',
      'diesel',
      'fastag',
      'toll',
      'makemytrip',
      'flight',
      'hotel',
    ])) {
      return 'Transport';
    }

    if (_containsAny(text, const [
      'electricity',
      'power',
      'water',
      'gas',
      'broadband',
      'internet',
      'bill',
      'recharge',
      'airtel',
      'jio',
      'vodafone',
      'bsnl',
    ])) {
      return 'Bills';
    }

    if (_containsAny(text, const [
      'netflix',
      'spotify',
      'hotstar',
      'youtube',
      'movie',
      'pvr',
      'inox',
      'bookmyshow',
    ])) {
      return 'Entertainment';
    }

    if (_containsAny(text, const ['atm', 'cash', 'withdrawn'])) {
      return 'Cash';
    }

    return 'Other';
  }

  static bool _containsAny(String text, List<String> needles) {
    return needles.any(text.contains);
  }
}

/// Riverpod provider exposing the SmsSyncService instance.
final smsSyncServiceProvider = Provider<SmsSyncService>((ref) {
  return SmsSyncService(
    smsRepo: ref.watch(smsRepositoryProvider),
    txRepo: ref.watch(transactionRepositoryProvider),
    permissionService: ref.watch(permissionServiceProvider),
    prefs: ref.watch(preferencesServiceProvider),
  );
});
