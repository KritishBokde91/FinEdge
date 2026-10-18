import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finsight_ai/features/subscriptions/domain/usecases/detect_subscriptions_usecase.dart';
import 'package:finsight_ai/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:finsight_ai/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:finsight_ai/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finsight_ai/core/error/result.dart';

class MockSubscriptionRepository implements SubscriptionRepository {
  final List<SubscriptionEntity> _subscriptions = [];

  @override
  Stream<List<SubscriptionEntity>> watchAllSubscriptions() {
    return Stream.value(List.unmodifiable(_subscriptions));
  }

  @override
  Future<Result<void>> insertSubscription(SubscriptionEntity subscription) async {
    _subscriptions.add(subscription);
    return const Right(null);
  }

  @override
  Future<Result<void>> updateSubscription(SubscriptionEntity subscription) async {
    final index = _subscriptions.indexWhere((s) => s.id == subscription.id);
    if (index >= 0) _subscriptions[index] = subscription;
    return const Right(null);
  }

  @override
  Future<Result<void>> deleteSubscription(String id) async {
    _subscriptions.removeWhere((s) => s.id == id);
    return const Right(null);
  }

  @override
  Future<SubscriptionEntity?> matchTransactionToSubscription(String merchant, double amount) async {
    return null;
  }

  @override
  Future<void> updateNextPaymentDateAfterCharge(String subscriptionId, DateTime chargeDate) async {}
}

void main() {
  late MockSubscriptionRepository repo;
  late DetectSubscriptionsUseCase useCase;

  setUp(() {
    repo = MockSubscriptionRepository();
    useCase = DetectSubscriptionsUseCase(repo);
  });

  test('detects monthly recurring subscription with 2+ occurrences within 10% amount variation', () async {
    final transactions = [
      TransactionEntity(
        id: 'tx_netflix_1',
        smsId: 's1',
        amount: 499.0,
        merchant: 'Netflix',
        category: 'Entertainment',
        timestamp: DateTime(2026, 1, 15, 10, 0),
        isIncome: false,
        accountSource: 'HDFC Bank',
      ),
      TransactionEntity(
        id: 'tx_netflix_2',
        smsId: 's2',
        amount: 499.0,
        merchant: 'Netflix',
        category: 'Entertainment',
        timestamp: DateTime(2026, 2, 14, 10, 0),
        isIncome: false,
        accountSource: 'HDFC Bank',
      ),
      TransactionEntity(
        id: 'tx_netflix_3',
        smsId: 's3',
        amount: 499.0,
        merchant: 'Netflix',
        category: 'Entertainment',
        timestamp: DateTime(2026, 3, 16, 10, 0),
        isIncome: false,
        accountSource: 'HDFC Bank',
      ),
    ];

    final detected = useCase.detect(transactions);
    expect(detected.length, equals(1));
    expect(detected.first.merchant, equals('Netflix'));
    expect(detected.first.billingCycle, equals('monthly'));
    expect(detected.first.amount, equals(499.0));

    final savedCount = await useCase.detectAndSave(transactions);
    expect(savedCount, equals(1));

    // Saving again avoids duplicates
    final secondRun = await useCase.detectAndSave(transactions);
    expect(secondRun, equals(0));
  });

  test('ignores one-off transactions and income transactions', () {
    final transactions = [
      TransactionEntity(
        id: 'tx_income',
        smsId: 's4',
        amount: 50000.0,
        merchant: 'Company',
        category: 'Salary',
        timestamp: DateTime(2026, 1, 1),
        isIncome: true,
        accountSource: 'SBI',
      ),
      TransactionEntity(
        id: 'tx_income_2',
        smsId: 's5',
        amount: 50000.0,
        merchant: 'Company',
        category: 'Salary',
        timestamp: DateTime(2026, 2, 1),
        isIncome: true,
        accountSource: 'SBI',
      ),
      TransactionEntity(
        id: 'tx_oneoff',
        smsId: 's6',
        amount: 1200.0,
        merchant: 'Zara',
        category: 'Shopping',
        timestamp: DateTime(2026, 2, 10),
        isIncome: false,
        accountSource: 'HDFC',
      ),
    ];

    final detected = useCase.detect(transactions);
    expect(detected, isEmpty);
  });
}
