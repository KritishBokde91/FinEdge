import 'package:uuid/uuid.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';

/// Detected subscription from transaction history.
class DetectedSubscription {
  final String merchant;
  final double amount;
  final String billingCycle; // 'monthly', 'weekly', 'yearly'
  final DateTime nextBillingDate;
  final int occurrenceCount;

  const DetectedSubscription({
    required this.merchant,
    required this.amount,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.occurrenceCount,
  });
}

/// Automatically detects and persists recurring subscriptions from transaction history.
///
/// Ported from PennyWise's [AddSubscriptionUseCase] + [MarkSubscriptionPaidUseCase]:
/// - Groups expense transactions by merchant name
/// - Identifies recurring merchants (≥2 occurrences)
/// - Infers billing cycle from transaction intervals (monthly/weekly/yearly)
/// - Calculates next billing date
/// - Saves detected subscriptions (avoids duplicates)
class DetectSubscriptionsUseCase {
  final SubscriptionRepository _repository;
  static const _uuid = Uuid();

  // Minimum occurrences to be considered recurring (PennyWise uses 2+)
  static const _minOccurrences = 2;
  // Tolerance window for recurring detection (days)
  static const _monthlyToleranceDays = 7;
  static const _weeklyToleranceDays = 2;
  static const _yearlyToleranceDays = 14;

  const DetectSubscriptionsUseCase(this._repository);

  /// Scans [transactions] for recurring expenses and saves any newly detected
  /// subscriptions to the repository. Returns the count of new subscriptions saved.
  Future<int> detectAndSave(List<TransactionEntity> transactions) async {
    final detected = detect(transactions);
    final existing = await _repository.watchAllSubscriptions().first;
    final existingMerchants = existing.map((s) => s.merchant.toLowerCase()).toSet();

    int savedCount = 0;
    for (final sub in detected) {
      if (existingMerchants.contains(sub.merchant.toLowerCase())) continue;

      final entity = SubscriptionEntity(
        id: _uuid.v4(),
        merchant: sub.merchant,
        amount: sub.amount,
        billingCycle: sub.billingCycle,
        nextBillingDate: sub.nextBillingDate,
        isActive: true,
      );
      final result = await _repository.insertSubscription(entity);
      result.fold((_) {}, (_) => savedCount++);
    }
    return savedCount;
  }

  /// Pure detection logic — returns a list of detected recurring subscriptions
  /// without persisting them. Useful for preview/UI.
  List<DetectedSubscription> detect(List<TransactionEntity> transactions) {
    // Only analyze expense transactions
    final expenses = transactions
        .where((tx) => !tx.isIncome && tx.amount > 0)
        .toList();

    // Group by merchant
    final Map<String, List<TransactionEntity>> byMerchant = {};
    for (final tx in expenses) {
      byMerchant.putIfAbsent(tx.merchant, () => []).add(tx);
    }

    final detected = <DetectedSubscription>[];

    for (final entry in byMerchant.entries) {
      final merchant = entry.key;
      final txList = entry.value..sort(
        (a, b) => a.timestamp.compareTo(b.timestamp),
      );

      if (txList.length < _minOccurrences) continue;

      // Check if amounts are similar (within 10% variation — PennyWise tolerance)
      final amounts = txList.map((t) => t.amount).toList();
      final avgAmount = amounts.reduce((a, b) => a + b) / amounts.length;
      final allSimilar = amounts.every(
        (a) => (a - avgAmount).abs() / avgAmount < 0.1,
      );

      if (!allSimilar) continue;

      // Detect billing cycle from average interval
      final cycle = _inferBillingCycle(txList);
      if (cycle == null) continue;

      final nextBillingDate = _estimateNextBillingDate(txList.last.timestamp, cycle);

      detected.add(
        DetectedSubscription(
          merchant: merchant,
          amount: avgAmount,
          billingCycle: cycle,
          nextBillingDate: nextBillingDate,
          occurrenceCount: txList.length,
        ),
      );
    }

    return detected;
  }

  /// Infers the billing cycle by computing the average interval between transactions.
  String? _inferBillingCycle(List<TransactionEntity> sorted) {
    if (sorted.length < 2) return null;

    final intervals = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      intervals.add(
        sorted[i].timestamp.difference(sorted[i - 1].timestamp).inDays.abs(),
      );
    }

    final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;

    // Weekly: ~7 days ±2
    if ((avgInterval - 7).abs() <= _weeklyToleranceDays) return 'weekly';
    // Monthly: ~30 days ±7
    if ((avgInterval - 30).abs() <= _monthlyToleranceDays) return 'monthly';
    // Bimonthly: ~60 days ±7
    if ((avgInterval - 60).abs() <= _monthlyToleranceDays) return 'bimonthly';
    // Quarterly: ~90 days ±14
    if ((avgInterval - 90).abs() <= _yearlyToleranceDays) return 'quarterly';
    // Yearly: ~365 days ±14
    if ((avgInterval - 365).abs() <= _yearlyToleranceDays) return 'yearly';

    return null;
  }

  /// Projects the next billing date from the last known payment date.
  DateTime _estimateNextBillingDate(DateTime lastDate, String cycle) {
    return switch (cycle) {
      'weekly' => lastDate.add(const Duration(days: 7)),
      'bimonthly' => lastDate.add(const Duration(days: 60)),
      'quarterly' => DateTime(lastDate.year, lastDate.month + 3, lastDate.day),
      'yearly' => DateTime(lastDate.year + 1, lastDate.month, lastDate.day),
      _ => DateTime(lastDate.year, lastDate.month + 1, lastDate.day), // monthly
    };
  }
}
