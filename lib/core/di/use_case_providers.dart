import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_providers.dart';
import '../../features/transactions/domain/usecases/get_transaction_stats_usecase.dart';
import '../../features/transactions/domain/usecases/add_manual_transaction_usecase.dart';
import '../../features/budget_planner/domain/usecases/manage_budget_usecase.dart';
import '../../features/financial_goals/domain/usecases/manage_goal_usecase.dart';
import '../../features/subscriptions/domain/usecases/detect_subscriptions_usecase.dart';
import '../../features/notifications/domain/usecases/generate_notifications_usecase.dart';

// ── Transaction Use Cases ───────────────────────────────────────────────────

/// Provides [GetTransactionStatsUseCase] — pure computation, no repository needed.
final getTransactionStatsUseCaseProvider =
    Provider<GetTransactionStatsUseCase>((ref) {
  return const GetTransactionStatsUseCase();
});

/// Provides [AddManualTransactionUseCase] wired to the transaction repository.
final addManualTransactionUseCaseProvider =
    Provider<AddManualTransactionUseCase>((ref) {
  return AddManualTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

// ── Budget Use Cases ────────────────────────────────────────────────────────

/// Provides [ManageBudgetUseCase] wired to the budget repository.
final manageBudgetUseCaseProvider = Provider<ManageBudgetUseCase>((ref) {
  return ManageBudgetUseCase(ref.watch(budgetRepositoryProvider));
});

// ── Goal Use Cases ──────────────────────────────────────────────────────────

/// Provides [ManageGoalUseCase] wired to the goal repository.
final manageGoalUseCaseProvider = Provider<ManageGoalUseCase>((ref) {
  return ManageGoalUseCase(ref.watch(goalRepositoryProvider));
});

// ── Subscription Use Cases ──────────────────────────────────────────────────

/// Provides [DetectSubscriptionsUseCase] wired to the subscription repository.
final detectSubscriptionsUseCaseProvider =
    Provider<DetectSubscriptionsUseCase>((ref) {
  return DetectSubscriptionsUseCase(ref.watch(subscriptionRepositoryProvider));
});

// ── Notification Use Cases ──────────────────────────────────────────────────

/// Provides [GenerateNotificationsUseCase] wired to the notification repository.
final generateNotificationsUseCaseProvider =
    Provider<GenerateNotificationsUseCase>((ref) {
  return GenerateNotificationsUseCase(
    ref.watch(notificationRepositoryProvider),
  );
});

// ── Aggregate Providers ─────────────────────────────────────────────────────

/// Streams all transactions and computes full stats — used by Analytics page.
final transactionStatsProvider =
    StreamProvider<TransactionStats>((ref) async* {
  final txRepository = ref.watch(transactionRepositoryProvider);
  final useCase = ref.watch(getTransactionStatsUseCaseProvider);

  await for (final transactions in txRepository.watchAllTransactions()) {
    yield useCase.execute(transactions);
  }
});

/// Returns stats for the current month only.
final currentMonthStatsProvider =
    StreamProvider<TransactionStats>((ref) async* {
  final txRepository = ref.watch(transactionRepositoryProvider);
  final useCase = ref.watch(getTransactionStatsUseCaseProvider);

  final now = DateTime.now();
  await for (final transactions in txRepository.watchAllTransactions()) {
    yield useCase.executeForMonth(
      transactions,
      year: now.year,
      month: now.month,
    );
  }
});

final categoryAggregatesProvider =
    StreamProvider<Map<String, double>>((ref) async* {
  final txRepository = ref.watch(transactionRepositoryProvider);
  final useCase = ref.watch(getTransactionStatsUseCaseProvider);

  await for (final transactions in txRepository.watchAllTransactions()) {
    final stats = useCase.execute(transactions);
    yield stats.categoryTotals;
  }
});
