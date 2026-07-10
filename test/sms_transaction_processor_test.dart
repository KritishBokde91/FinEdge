import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:fpdart/fpdart.dart';
import 'package:finsight_ai/core/error/result.dart';
import 'package:finsight_ai/core/error/failures.dart';
import 'package:finsight_ai/core/database/drift_database.dart';
import 'package:finsight_ai/core/repositories/account_balance_repository.dart';
import 'package:finsight_ai/core/repositories/card_repository.dart';
import 'package:finsight_ai/core/repositories/merchant_mapping_repository.dart';
import 'package:finsight_ai/core/repositories/rule_repository.dart';
import 'package:finsight_ai/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:finsight_ai/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:finsight_ai/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finsight_ai/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finsight_ai/features/rules/domain/services/rule_engine.dart';
import 'package:finsight_ai/features/rules/domain/entities/transaction_rule.dart';
import 'package:finsight_ai/features/rules/domain/entities/rule_application.dart';
import 'package:finsight_ai/features/rules/domain/entities/rule_condition.dart';
import 'package:finsight_ai/features/rules/domain/entities/rule_action.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/sms_transaction_processor.dart';

// --- Manual Mock Implementations ---

class MockTransactionRepository implements TransactionRepository {
  final Map<String, TransactionEntity> database = {};

  @override
  Stream<List<TransactionEntity>> watchAllTransactions() => Stream.value(database.values.toList());

  @override
  Future<Result<TransactionEntity>> getTransactionById(String id) async {
    final tx = database[id];
    if (tx == null) return const Left(DatabaseFailure('Not found'));
    return Right(tx);
  }

  @override
  Future<Result<void>> insertTransaction(TransactionEntity transaction) async {
    database[transaction.id] = transaction;
    return const Right(null);
  }

  @override
  Future<Result<void>> updateTransaction(TransactionEntity transaction) async {
    database[transaction.id] = transaction;
    return const Right(null);
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    database.remove(id);
    return const Right(null);
  }

  @override
  Future<Result<Map<String, double>>> calculateCategoryAggregates() async {
    return const Right({});
  }

  @override
  Future<List<TransactionEntity>> findPotentialDuplicates(TransactionEntity transaction) async {
    return [];
  }
}

class MockAccountBalanceRepository implements AccountBalanceRepository {
  final List<AccountBalancesTableCompanion> balances = [];

  @override
  Future<List<AccountBalancesTableData>> getBalances() async => [];

  @override
  Stream<List<AccountBalancesTableData>> watchBalances() => Stream.value([]);

  @override
  Future<int> insertRawBalance(AccountBalancesTableCompanion entry) async {
    balances.add(entry);
    return balances.length;
  }

  @override
  Future<bool> isManualAccount(String bankName, String accountLast4) async => false;

  @override
  Future<double> signedTransactionSum(String bankName, String accountLast4) async => 0.0;

  @override
  Future<void> ensureManualOpening(String bankName, String accountLast4) async {}

  @override
  Future<void> recomputeManualBalance(String bankName, String accountLast4) async {}

  @override
  Future<void> setManualCurrentBalance(String bankName, String accountLast4, double target) async {}

  @override
  Future<void> updateManualBalanceAndCurrency(
      String bankName, String accountLast4, String currency, double targetBalance) async {}

  @override
  Future<void> seedManualAccount(AccountBalancesTableCompanion template, double openingBalance) async {}

  @override
  Future<AccountBalancesTableData?> getLatestBalance(String bankName, String accountLast4) async {
    final matches = balances.where((b) => b.bankName.value == bankName && b.accountLast4.value == accountLast4).toList();
    if (matches.isEmpty) return null;

    final last = matches.last;
    return AccountBalancesTableData(
      id: balances.indexOf(last) + 1,
      bankName: last.bankName.value,
      accountLast4: last.accountLast4.value,
      balance: last.balance.value,
      timestamp: last.timestamp.value,
      transactionId: last.transactionId.value,
      creditLimit: last.creditLimit.value,
      isCreditCard: last.isCreditCard.value,
      smsSource: last.smsSource.value,
      sourceType: last.sourceType.value,
      currency: last.currency.value,
      profileId: last.profileId.value,
      alias: last.alias.value,
      lowBalanceThreshold: last.lowBalanceThreshold.value,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<int> deleteBalancesForTransaction(String transactionId) async {
    balances.removeWhere((b) => b.transactionId.value == transactionId);
    return 1;
  }
}

class MockCardRepository implements CardRepository {
  final List<CardsTableData> cards = [];

  @override
  Future<CardsTableData?> getCard(String bankName, String cardLast4) async {
    final matches = cards.where((c) => c.bankName == bankName && c.cardLast4 == cardLast4);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<int> insertCard(CardsTableCompanion entry) async {
    final newCard = CardsTableData(
      id: cards.length + 1,
      bankName: entry.bankName.value,
      cardLast4: entry.cardLast4.value,
      accountLast4: entry.accountLast4.value,
      cardType: entry.cardType.value,
      isActive: entry.isActive.value,
      creditLimit: entry.creditLimit.value,
    );
    cards.add(newCard);
    return newCard.id;
  }

  @override
  Future<List<CardsTableData>> getActiveCards() async => cards;

  @override
  Future<void> setCardActive(int cardId, bool isActive) async {}

  @override
  Future<void> linkCardToAccount(int cardId, String? accountLast4) async {}

  @override
  Future<void> findOrCreateCard({
    required String cardLast4,
    required String bankName,
    required bool isCredit,
  }) async {
    final existing = await getCard(bankName, cardLast4);
    if (existing == null) {
      await insertCard(
        CardsTableCompanion(
          bankName: Value(bankName),
          cardLast4: Value(cardLast4),
          cardType: Value(isCredit ? 'CREDIT' : 'DEBIT'),
          isActive: const Value(true),
        ),
      );
    }
  }
}

class MockMerchantMappingRepository implements MerchantMappingRepository {
  final Map<String, String> mappings = {};

  @override
  Future<int> insertMapping(MerchantMappingsTableCompanion entry) async {
    mappings[entry.rawMerchant.value] = entry.cleanMerchant.value;
    return 1;
  }

  @override
  Future<MerchantMappingsTableData?> getMappingByRaw(String raw) async {
    final clean = mappings[raw];
    if (clean == null) return null;
    return MerchantMappingsTableData(id: 1, rawMerchant: raw, cleanMerchant: clean);
  }

  @override
  Future<String?> getCategoryForMerchant(String merchantName) async {
    return mappings[merchantName];
  }

  @override
  Future<Map<String, String>> getAllMappingsAsMap() async => mappings;
}

class MockSubscriptionRepository implements SubscriptionRepository {
  SubscriptionEntity? matchedSub;
  String? chargedSubId;
  DateTime? chargedDate;

  @override
  Stream<List<SubscriptionEntity>> watchAllSubscriptions() => Stream.value([]);

  @override
  Future<Result<void>> insertSubscription(SubscriptionEntity subscription) async => const Right(null);

  @override
  Future<Result<void>> updateSubscription(SubscriptionEntity subscription) async => const Right(null);

  @override
  Future<Result<void>> deleteSubscription(String id) async => const Right(null);

  @override
  Future<SubscriptionEntity?> matchTransactionToSubscription(String merchant, double amount) async {
    return matchedSub;
  }

  @override
  Future<void> updateNextPaymentDateAfterCharge(String subscriptionId, DateTime chargeDate) async {
    chargedSubId = subscriptionId;
    chargedDate = chargeDate;
  }
}

class MockRuleRepository implements RuleRepository {
  final List<TransactionRule> rules = [];
  final List<RuleApplication> applications = [];

  @override
  Future<int> insertRule(TransactionRule rule) async {
    rules.add(rule);
    return 1;
  }

  @override
  Future<List<TransactionRule>> getRules() async => rules;

  @override
  Stream<List<TransactionRule>> watchRules() => Stream.value(rules);

  @override
  Future<int> deleteRule(String id) async {
    rules.removeWhere((r) => r.id == id);
    return 1;
  }

  @override
  Future<int> insertApplication(RuleApplication app) async {
    applications.add(app);
    return 1;
  }

  @override
  Future<List<RuleApplication>> getApplicationsForRule(String ruleId) async {
    return applications.where((a) => a.ruleId == ruleId).toList();
  }

  @override
  Future<int> deleteRuleApplicationsForTransaction(String transactionId) async {
    applications.removeWhere((a) => a.transactionId == transactionId);
    return 1;
  }

  @override
  Future<void> saveRuleApplications(List<RuleApplication> ruleApps) async {
    applications.addAll(ruleApps);
  }

  @override
  Future<List<TransactionRule>> getActiveRulesByType(bool isIncome) async {
    return rules.where((r) => r.isActive).toList();
  }
}

// --- Tests main block ---

void main() {
  late MockTransactionRepository txRepo;
  late MockAccountBalanceRepository balanceRepo;
  late MockCardRepository cardRepo;
  late MockMerchantMappingRepository mappingRepo;
  late MockSubscriptionRepository subRepo;
  late MockRuleRepository ruleRepo;
  late SmsTransactionProcessor processor;

  setUp(() {
    txRepo = MockTransactionRepository();
    balanceRepo = MockAccountBalanceRepository();
    cardRepo = MockCardRepository();
    mappingRepo = MockMerchantMappingRepository();
    subRepo = MockSubscriptionRepository();
    ruleRepo = MockRuleRepository();

    processor = SmsTransactionProcessor(
      transactionRepository: txRepo,
      accountBalanceRepository: balanceRepo,
      cardRepository: cardRepo,
      merchantMappingRepository: mappingRepo,
      subscriptionRepository: subRepo,
      ruleRepository: ruleRepo,
      ruleEngine: const RuleEngine(),
    );
  });

  group('SmsTransactionProcessor saves and deduplicates correctly', () {
    test('Should parse HDFC SMS and save transaction with correct balance', () async {
      final result = await processor.processAndSaveTransaction(
        'HDFCBank',
        'Rs 100.00 debited from A/C X1234 on 10-Jul-2026. Bal: Rs 5432.10.',
        1783670400000, // 10-Jul-2026
      );

      expect(result.success, isTrue);
      expect(result.transactionId, isNotNull);

      // Check transaction saved
      expect(txRepo.database.length, equals(1));
      final tx = txRepo.database.values.first;
      expect(tx.amount, equals(100.0));
      expect(tx.isIncome, isFalse);
      expect(tx.accountSource, equals('HDFC Bank'));

      // Check balance saved
      expect(balanceRepo.balances.length, equals(1));
      final bal = balanceRepo.balances.first;
      expect(bal.bankName.value, equals('HDFC Bank'));
      expect(bal.accountLast4.value, equals('1234'));
      expect(bal.balance.value, equals(5432.10));
    });

    test('Should skip duplicate transactions based on MD5 ID hash', () async {
      const smsTime = 1783670400000;
      final result1 = await processor.processAndSaveTransaction(
        'HDFCBank',
        'Rs 100.00 debited from A/C X1234 on 10-Jul-2026.',
        smsTime,
      );
      expect(result1.success, isTrue);

      final result2 = await processor.processAndSaveTransaction(
        'HDFCBank',
        'Rs 100.00 debited from A/C X1234 on 10-Jul-2026.',
        smsTime,
      );
      expect(result2.success, isFalse);
      expect(result2.reason, equals('Duplicate transaction'));
    });
  });

  group('SmsTransactionProcessor applies rules and maps categories', () {
    test('Should apply classification and mapping rules correctly', () async {
      // Add custom rule
      await ruleRepo.insertRule(
        TransactionRule(
          name: 'Netflix rule',
          conditions: [
            const RuleCondition(
              field: TransactionField.merchant,
              operator: ConditionOperator.contains,
              value: 'Netflix',
            ),
          ],
          actions: [
            const RuleAction(
              field: TransactionField.category,
              actionType: ActionType.set,
              value: 'Sub: Entertainment',
            ),
          ],
        ),
      );

      final result = await processor.processAndSaveTransaction(
        'HDFCBank',
        'Rs 199.00 debited from A/C X1234 for NETFLIX on 10-Jul-2026.',
        1783670400000,
      );

      expect(result.success, isTrue);
      final tx = txRepo.database.values.first;
      expect(tx.category, equals('Sub: Entertainment'));
    });

    test('Should block transactions based on blocking rules', () async {
      // Add blocking rule
      await ruleRepo.insertRule(
        TransactionRule(
          name: 'Block promotional alerts',
          conditions: [
            const RuleCondition(
              field: TransactionField.smsText,
              operator: ConditionOperator.contains,
              value: 'Promo',
            ),
          ],
          actions: [
            const RuleAction(
              field: TransactionField.merchant,
              actionType: ActionType.block,
              value: '',
            ),
          ],
        ),
      );

      final result = await processor.processAndSaveTransaction(
        'HDFCBank',
        'Rs 100.00 debited from A/C X1234 on 10-Jul-2026. Promo code: WINTER50.',
        1783670400000,
      );

      expect(result.success, isFalse);
      expect(result.reason, contains('Blocked by rule'));
    });
  });
}
