import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/repositories/account_balance_repository.dart';
import '../../../../core/repositories/card_repository.dart';
import '../../../../core/repositories/merchant_mapping_repository.dart';
import '../../../../core/repositories/rule_repository.dart';
import '../../../../features/subscriptions/domain/repositories/subscription_repository.dart';
import '../../../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../../../features/transactions/domain/entities/transaction_entity.dart';
import '../../../../features/rules/domain/services/rule_engine.dart';
import '../../../../features/rules/domain/entities/rule_application.dart';
import '../../../../core/di/core_repository_providers.dart';
import '../../../../core/di/repository_providers.dart';
import '../../domain/entities/parsed_transaction.dart';
import '../../domain/services/bank/bank_parser_factory.dart';
import '../../domain/services/parsed_transaction_mapper.dart';

class ProcessingResult {
  final bool success;
  final String? transactionId;
  final String? reason;

  const ProcessingResult(this.success, {this.transactionId, this.reason});
}

/// Shared processor for SMS transactions.
///
/// Ported from `SmsTransactionProcessor.kt`.
class SmsTransactionProcessor {
  final TransactionRepository transactionRepository;
  final AccountBalanceRepository accountBalanceRepository;
  final CardRepository cardRepository;
  final MerchantMappingRepository merchantMappingRepository;
  final SubscriptionRepository subscriptionRepository;
  final RuleRepository ruleRepository;
  final RuleEngine ruleEngine;

  const SmsTransactionProcessor({
    required this.transactionRepository,
    required this.accountBalanceRepository,
    required this.cardRepository,
    required this.merchantMappingRepository,
    required this.subscriptionRepository,
    required this.ruleRepository,
    required this.ruleEngine,
  });

  /// Parses and saves a transaction from an SMS message.
  Future<ProcessingResult> processAndSaveTransaction(
    String sender,
    String body,
    int timestamp, {
    String? smsId,
  }) async {
    try {
      final parsers = BankParserFactory.getParsers(sender);
      if (parsers.isEmpty) {
        return ProcessingResult(
          false,
          reason: 'No parser found for sender: $sender',
        );
      }

      // Try every parser that handles this sender and use the first whose content parses
      ParsedTransaction? parsedTransaction;
      for (final parser in parsers) {
        try {
          final parsed = parser.parse(body, sender, timestamp);
          if (parsed != null) {
            parsedTransaction = parsed;
            break;
          }
        } catch (_) {}
      }

      if (parsedTransaction == null) {
        return const ProcessingResult(
          false,
          reason: 'Could not parse transaction from SMS',
        );
      }

      return await saveParsedTransaction(parsedTransaction, body, smsId: smsId);
    } catch (e) {
      return ProcessingResult(false, reason: e.toString());
    }
  }

  /// Saves a parsed transaction to the database with deduplication, mapping, rules, and balances.
  Future<ProcessingResult> saveParsedTransaction(
    ParsedTransaction parsedTransaction,
    String smsBody, {
    String? smsId,
  }) async {
    try {
      final normalizedMerchant = ParsedTransactionMapper.normalizeMerchantName(
        parsedTransaction.merchant ?? parsedTransaction.sender,
      );

      final transactionId =
          parsedTransaction.transactionHash ??
          parsedTransaction.generateTransactionId();

      final entity = TransactionEntity(
        id: transactionId,
        smsId: smsId,
        amount: parsedTransaction.amount,
        merchant: normalizedMerchant,
        category: _classifyCategory(normalizedMerchant, parsedTransaction.type),
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          parsedTransaction.timestamp,
        ),
        isIncome:
            parsedTransaction.type == TransactionType.income ||
            parsedTransaction.type == TransactionType.credit,
        accountSource: parsedTransaction.bankName,
        reference: parsedTransaction.reference,
        currency: parsedTransaction.currency,
      );

      // Check if this transaction already exists
      final existingRes = await transactionRepository.getTransactionById(
        entity.id,
      );
      final existingTransaction = existingRes.fold((_) => null, (tx) => tx);
      if (existingTransaction != null) {
        return const ProcessingResult(false, reason: 'Duplicate transaction');
      }

      // Check for custom merchant mapping
      var finalEntity = entity;
      final customCategory = await merchantMappingRepository
          .getCategoryForMerchant(entity.merchant);
      if (customCategory != null) {
        finalEntity = finalEntity.copyWith(category: customCategory);
      }

      // Apply rule engine
      final activeRules = await ruleRepository.getActiveRulesByType(
        finalEntity.isIncome,
      );

      // Check if transaction should be blocked
      final blockingRule = ruleEngine.shouldBlockTransaction(
        finalEntity,
        smsBody,
        activeRules,
      );
      if (blockingRule != null) {
        return ProcessingResult(
          false,
          reason: 'Blocked by rule: ${blockingRule.name}',
        );
      }

      final (entityWithRules, ruleApplications) = ruleEngine.evaluateRules(
        finalEntity,
        smsBody,
        activeRules,
      );
      finalEntity = entityWithRules;

      // Check subscription match
      final matchedSubscription = await subscriptionRepository
          .matchTransactionToSubscription(
            finalEntity.merchant,
            finalEntity.amount,
          );

      if (matchedSubscription != null) {
        await subscriptionRepository.updateNextPaymentDateAfterCharge(
          matchedSubscription.id,
          finalEntity.timestamp,
        );
      }

      final insertRes = await transactionRepository.insertTransaction(
        finalEntity,
      );
      return await insertRes.fold(
        (failure) => ProcessingResult(false, reason: failure.toString()),
        (_) async {
          // Save rule applications
          if (ruleApplications.isNotEmpty) {
            final mappedApps = ruleApplications.map((app) {
              return RuleApplication(
                id: app.id,
                ruleId: app.ruleId,
                ruleName: app.ruleName,
                transactionId: finalEntity.id,
                fieldsModified: app.fieldsModified,
                appliedAt: app.appliedAt,
              );
            }).toList();
            await ruleRepository.saveRuleApplications(mappedApps);
          }

          // Process balance updates
          await processBalanceUpdate(
            parsedTransaction,
            finalEntity,
            finalEntity.id,
          );

          return ProcessingResult(true, transactionId: finalEntity.id);
        },
      );
    } catch (e) {
      return ProcessingResult(false, reason: e.toString());
    }
  }

  Future<void> processBalanceUpdate(
    ParsedTransaction parsedTransaction,
    TransactionEntity entity,
    String transactionId,
  ) async {
    if (parsedTransaction.accountLast4 == null) {
      if (parsedTransaction.isMobileWallet &&
          parsedTransaction.balance != null) {
        await upsertWalletBalance(parsedTransaction, entity, transactionId);
      }
      return;
    }

    final isFromCard = parsedTransaction.isFromCard;
    String? targetAccountLast4;

    if (isFromCard) {
      var card = await cardRepository.getCard(
        parsedTransaction.bankName,
        parsedTransaction.accountLast4!,
      );
      if (card == null) {
        final isCredit = parsedTransaction.type == TransactionType.credit;
        await cardRepository.findOrCreateCard(
          cardLast4: parsedTransaction.accountLast4!,
          bankName: parsedTransaction.bankName,
          isCredit: isCredit,
        );
        card = await cardRepository.getCard(
          parsedTransaction.bankName,
          parsedTransaction.accountLast4!,
        );
      }

      if (card != null) {
        targetAccountLast4 = card.cardType.toUpperCase() == 'CREDIT'
            ? parsedTransaction.accountLast4
            : card.accountLast4 ?? parsedTransaction.accountLast4;
      } else {
        targetAccountLast4 = parsedTransaction.accountLast4;
      }
    } else {
      targetAccountLast4 = parsedTransaction.accountLast4;
    }

    if (targetAccountLast4 != null) {
      final card = await cardRepository.getCard(
        parsedTransaction.bankName,
        targetAccountLast4,
      );
      final isCreditCard =
          parsedTransaction.type == TransactionType.credit ||
          (card != null && card.cardType.toUpperCase() == 'CREDIT');

      final existingAccount = await accountBalanceRepository.getLatestBalance(
        parsedTransaction.bankName,
        targetAccountLast4,
      );

      double newBalance = 0.0;
      if (parsedTransaction.balance != null) {
        newBalance = parsedTransaction.balance!;
      } else if (isCreditCard) {
        final currentBalance = existingAccount?.balance ?? 0.0;
        newBalance = currentBalance + parsedTransaction.amount;
      } else if (existingAccount?.isCreditCard == true &&
          (parsedTransaction.type == TransactionType.income)) {
        final currentBalance = existingAccount?.balance ?? 0.0;
        newBalance = max(0.0, currentBalance - parsedTransaction.amount);
      } else {
        final currentBalance = existingAccount?.balance ?? 0.0;
        switch (parsedTransaction.type) {
          case TransactionType.income:
            newBalance = currentBalance + parsedTransaction.amount;
            break;
          case TransactionType.expense:
          case TransactionType.investment:
            newBalance = max(0.0, currentBalance - parsedTransaction.amount);
            break;
          default:
            newBalance = currentBalance;
            break;
        }
      }

      final resolvedCreditLimit =
          isCreditCard && parsedTransaction.creditLimit != null
          ? parsedTransaction.creditLimit! + newBalance
          : existingAccount?.creditLimit;

      final balanceEntity = AccountBalancesTableCompanion(
        bankName: Value(parsedTransaction.bankName),
        accountLast4: Value(targetAccountLast4),
        balance: Value(newBalance),
        timestamp: Value(entity.timestamp),
        transactionId: Value(transactionId),
        creditLimit: Value(resolvedCreditLimit),
        isCreditCard: Value(
          isCreditCard || (existingAccount?.isCreditCard ?? false),
        ),
        smsSource: Value(
          parsedTransaction.smsBody.substring(
            0,
            parsedTransaction.smsBody.length > 500
                ? 500
                : parsedTransaction.smsBody.length,
          ),
        ),
        sourceType: const Value('TRANSACTION'),
        currency: Value(parsedTransaction.currency),
        profileId: Value(existingAccount?.profileId ?? 1),
        alias: Value(existingAccount?.alias),
        lowBalanceThreshold: Value(existingAccount?.lowBalanceThreshold),
      );

      await accountBalanceRepository.insertRawBalance(balanceEntity);
    }
  }

  Future<void> upsertWalletBalance(
    ParsedTransaction parsedTransaction,
    TransactionEntity entity,
    String transactionId,
  ) async {
    final balance = parsedTransaction.balance ?? 0.0;
    const walletMarker = 'WALLET';

    final existingAccount = await accountBalanceRepository.getLatestBalance(
      parsedTransaction.bankName,
      walletMarker,
    );

    final balanceEntity = AccountBalancesTableCompanion(
      bankName: Value(parsedTransaction.bankName),
      accountLast4: const Value(walletMarker),
      balance: Value(balance),
      timestamp: Value(entity.timestamp),
      transactionId: Value(transactionId),
      creditLimit: const Value(null),
      isCreditCard: const Value(false),
      smsSource: Value(
        parsedTransaction.smsBody.substring(
          0,
          parsedTransaction.smsBody.length > 500
              ? 500
              : parsedTransaction.smsBody.length,
        ),
      ),
      sourceType: const Value('TRANSACTION'),
      currency: Value(parsedTransaction.currency),
      profileId: Value(existingAccount?.profileId ?? 1),
      alias: Value(existingAccount?.alias),
      lowBalanceThreshold: Value(existingAccount?.lowBalanceThreshold),
    );

    await accountBalanceRepository.insertRawBalance(balanceEntity);
  }

  String _classifyCategory(String merchant, TransactionType type) {
    final text = merchant.toLowerCase();
    if (type == TransactionType.income) return 'Salary';
    if (type == TransactionType.investment) return 'Investment';
    if (type == TransactionType.transfer) return 'Transfer';

    if (text.contains('swiggy') ||
        text.contains('zomato') ||
        text.contains('restaurant') ||
        text.contains('cafe') ||
        text.contains('food') ||
        text.contains('kfc') ||
        text.contains('mcdonald') ||
        text.contains('domino') ||
        text.contains('pizza') ||
        text.contains('starbucks')) {
      return 'Food';
    }

    if (text.contains('bigbasket') ||
        text.contains('blinkit') ||
        text.contains('zepto') ||
        text.contains('grocery') ||
        text.contains('dmart') ||
        text.contains('jiomart') ||
        text.contains('amazon') ||
        text.contains('flipkart') ||
        text.contains('myntra') ||
        text.contains('nykaa') ||
        text.contains('shopping') ||
        text.contains('store') ||
        text.contains('mart')) {
      return 'Shopping';
    }

    if (text.contains('uber') ||
        text.contains('ola') ||
        text.contains('rapido') ||
        text.contains('irctc') ||
        text.contains('metro') ||
        text.contains('fuel') ||
        text.contains('petrol') ||
        text.contains('diesel') ||
        text.contains('fastag') ||
        text.contains('toll') ||
        text.contains('makemytrip') ||
        text.contains('flight') ||
        text.contains('hotel')) {
      return 'Transport';
    }

    if (text.contains('electricity') ||
        text.contains('power') ||
        text.contains('water') ||
        text.contains('gas') ||
        text.contains('broadband') ||
        text.contains('internet') ||
        text.contains('bill') ||
        text.contains('recharge') ||
        text.contains('airtel') ||
        text.contains('jio') ||
        text.contains('vodafone') ||
        text.contains('bsnl')) {
      return 'Bills';
    }

    if (text.contains('netflix') ||
        text.contains('spotify') ||
        text.contains('hotstar') ||
        text.contains('youtube') ||
        text.contains('movie') ||
        text.contains('pvr') ||
        text.contains('inox') ||
        text.contains('bookmyshow')) {
      return 'Entertainment';
    }

    if (text.contains('atm') ||
        text.contains('cash') ||
        text.contains('withdrawn')) {
      return 'Cash';
    }

    return 'Other';
  }
}

/// Riverpod provider for SmsTransactionProcessor.
final smsTransactionProcessorProvider = Provider<SmsTransactionProcessor>((
  ref,
) {
  return SmsTransactionProcessor(
    transactionRepository: ref.watch(transactionRepositoryProvider),
    accountBalanceRepository: ref.watch(accountBalanceRepositoryProvider),
    cardRepository: ref.watch(cardRepositoryProvider),
    merchantMappingRepository: ref.watch(merchantMappingRepositoryProvider),
    subscriptionRepository: ref.watch(subscriptionRepositoryProvider),
    ruleRepository: ref.watch(ruleRepositoryProvider),
    ruleEngine: const RuleEngine(),
  );
});
