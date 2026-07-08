import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/sms_intelligence/domain/repositories/sms_repository.dart';
import '../../features/sms_intelligence/data/repositories/sms_repository_impl.dart';
import '../../features/budget_planner/domain/repositories/budget_repository.dart';
import '../../features/budget_planner/data/repositories/budget_repository_impl.dart';
import '../../features/financial_goals/domain/repositories/goal_repository.dart';
import '../../features/financial_goals/data/repositories/goal_repository_impl.dart';
import '../../features/subscriptions/domain/repositories/subscription_repository.dart';
import '../../features/subscriptions/data/repositories/subscription_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../services/permission_service.dart';

/// Provider exposing the abstract TransactionRepository contract mapped to concrete impl.
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(ref.watch(databaseProvider));
});

/// Provider exposing the abstract SmsRepository contract mapped to concrete impl.
final smsRepositoryProvider = Provider<SmsRepository>((ref) {
  return SmsRepositoryImpl(ref.watch(databaseProvider));
});

/// Provider exposing the abstract BudgetRepository contract mapped to concrete impl.
final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(databaseProvider));
});

/// Provider exposing the abstract GoalRepository contract mapped to concrete impl.
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepositoryImpl(ref.watch(databaseProvider));
});

/// Provider exposing the abstract SubscriptionRepository contract mapped to concrete impl.
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl(ref.watch(databaseProvider));
});

/// Provider exposing the abstract NotificationRepository contract mapped to concrete impl.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(databaseProvider));
});

/// Provider for system permission checking operations.
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});
