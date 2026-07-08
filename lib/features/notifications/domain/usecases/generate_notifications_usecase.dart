import 'package:uuid/uuid.dart';
import '../../../budget_planner/domain/entities/budget_entity.dart';
import '../../../financial_goals/domain/entities/goal_entity.dart';
import '../../../subscriptions/domain/entities/subscription_entity.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

/// Generates in-app notifications based on financial activity.
///
/// Ported from PennyWise's notification generation logic:
/// - Budget overrun alert: triggers when spending > 80% of limit
/// - Budget exceeded alert: triggers when spending > 100% of limit
/// - Upcoming subscription billing: triggers when billing date ≤ 3 days away
/// - Goal milestone: triggers at 50%, 80%, and 100% completion
///
/// All notifications are deduplicated via the [referenceId] field using
/// a composite key so the same alert doesn't fire twice for the same event.
class GenerateNotificationsUseCase {
  final NotificationRepository _repository;
  static const _uuid = Uuid();

  // PennyWise thresholds
  static const _budgetWarningThreshold = 0.80;
  static const _budgetExceededThreshold = 1.00;
  static const _subscriptionDaysAhead = 3;

  const GenerateNotificationsUseCase(this._repository);

  /// Run all notification checks and persist new notifications.
  /// Returns the count of new notifications generated.
  Future<int> execute({
    required List<BudgetEntity> budgets,
    required List<TransactionEntity> transactions,
    required List<GoalEntity> goals,
    required List<SubscriptionEntity> subscriptions,
  }) async {
    // Fetch existing dedup keys from the database once
    final existingNotifications =
        await _repository.watchAllNotifications().first;
    final existingKeys =
        existingNotifications.map((n) => n.type).toSet(); // we encode key in type

    int count = 0;
    count += await _checkBudgets(budgets, transactions, existingKeys);
    count += await _checkSubscriptions(subscriptions, existingKeys);
    count += await _checkGoals(goals, existingKeys);
    return count;
  }

  /// Budget overrun / warning notifications.
  Future<int> _checkBudgets(
    List<BudgetEntity> budgets,
    List<TransactionEntity> transactions,
    Set<String> existingKeys,
  ) async {
    int count = 0;
    for (final budget in budgets) {
      // Calculate spending for this budget's category and period
      final spent = transactions
          .where((tx) =>
              !tx.isIncome &&
              tx.category == budget.category &&
              !tx.timestamp.isBefore(budget.startDate) &&
              !tx.timestamp.isAfter(budget.endDate))
          .fold(0.0, (sum, tx) => sum + tx.amount);

      final ratio = budget.limitAmount > 0 ? spent / budget.limitAmount : 0.0;

      String? title;
      String? body;
      String? dedupKey;

      if (ratio >= _budgetExceededThreshold) {
        dedupKey = 'budget_exceeded_${budget.id}';
        title = '⚠️ Budget Exceeded: ${budget.category}';
        body =
            'You\'ve spent ₹${spent.toStringAsFixed(0)} against your ₹${budget.limitAmount.toStringAsFixed(0)} budget.';
      } else if (ratio >= _budgetWarningThreshold) {
        final pct = (ratio * 100).toInt();
        dedupKey = 'budget_warning_${budget.id}';
        title = '🔔 Budget Alert: ${budget.category}';
        body =
            'You\'ve used $pct% of your ${budget.category} budget. ₹${(budget.limitAmount - spent).toStringAsFixed(0)} remaining.';
      }

      if (title != null && body != null && dedupKey != null) {
        if (!existingKeys.contains(dedupKey)) {
          await _saveNotification(
            title: title,
            body: body,
            dedupKey: dedupKey,
          );
          existingKeys.add(dedupKey);
          count++;
        }
      }
    }
    return count;
  }

  /// Upcoming subscription billing notifications.
  Future<int> _checkSubscriptions(
    List<SubscriptionEntity> subscriptions,
    Set<String> existingKeys,
  ) async {
    int count = 0;
    final now = DateTime.now();
    for (final sub in subscriptions) {
      if (!sub.isActive) continue;
      final daysUntil = sub.nextBillingDate.difference(now).inDays;
      if (daysUntil < 0 || daysUntil > _subscriptionDaysAhead) continue;

      final dedupKey =
          'sub_${sub.id}_${sub.nextBillingDate.millisecondsSinceEpoch}';
      if (!existingKeys.contains(dedupKey)) {
        final dayLabel = daysUntil == 0
            ? 'today'
            : daysUntil == 1
                ? 'tomorrow'
                : 'in $daysUntil days';
        await _saveNotification(
          title: '📅 Upcoming Subscription: ${sub.merchant}',
          body:
              '₹${sub.amount.toStringAsFixed(0)} will be billed $dayLabel (${sub.billingCycle}).',
          dedupKey: dedupKey,
        );
        existingKeys.add(dedupKey);
        count++;
      }
    }
    return count;
  }

  /// Goal milestone notifications (50%, 80%, 100%).
  Future<int> _checkGoals(
    List<GoalEntity> goals,
    Set<String> existingKeys,
  ) async {
    int count = 0;
    for (final goal in goals) {
      if (goal.targetAmount <= 0) continue;
      final ratio = goal.currentAmount / goal.targetAmount;

      int? milestone;
      if (ratio >= 1.0) {
        milestone = 100;
      } else if (ratio >= 0.8) {
        milestone = 80;
      } else if (ratio >= 0.5) {
        milestone = 50;
      }

      if (milestone != null) {
        final dedupKey = 'goal_${goal.id}_$milestone';
        if (!existingKeys.contains(dedupKey)) {
          final isComplete = milestone == 100;
          await _saveNotification(
            title: isComplete
                ? '🎉 Goal Achieved: ${goal.title}'
                : '🎯 Goal Milestone: ${goal.title}',
            body: isComplete
                ? 'Congratulations! You\'ve reached your target of ₹${goal.targetAmount.toStringAsFixed(0)}.'
                : 'You\'re $milestone% of the way to your ₹${goal.targetAmount.toStringAsFixed(0)} goal.',
            dedupKey: dedupKey,
          );
          existingKeys.add(dedupKey);
          count++;
        }
      }
    }
    return count;
  }

  Future<void> _saveNotification({
    required String title,
    required String body,
    required String dedupKey,
  }) async {
    // We encode the dedup key inside the `type` field for deduplication.
    final entity = NotificationEntity(
      id: _uuid.v4(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      type: dedupKey,
      isRead: false,
    );
    await _repository.insertNotification(entity);
  }
}
