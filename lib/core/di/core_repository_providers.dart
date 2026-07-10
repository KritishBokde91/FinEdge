import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart';
import '../services/receipt_manager_service.dart';
import '../../main.dart';

// Separate Repository Imports
import '../repositories/account_balance_repository.dart';
import '../repositories/card_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/loan_repository.dart';
import '../repositories/merchant_mapping_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/rule_repository.dart';
import '../repositories/transaction_group_repository.dart';
import '../repositories/unrecognized_sms_repository.dart';
import '../repositories/ai_context_repository.dart';
import '../repositories/app_lock_repository.dart';
import '../repositories/bank_notification_repository.dart';
import '../repositories/budget_group_repository.dart';
import '../repositories/llm_repository.dart';
import '../repositories/model_repository.dart';

/// Provider for local receipt file storage manager.
final receiptManagerServiceProvider = Provider<ReceiptManagerService>((ref) {
  return const ReceiptManagerService();
});

/// Provider for bank account balance repository coordinator.
final accountBalanceRepositoryProvider = Provider<AccountBalanceRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AccountBalanceRepository(db.accountBalanceDao, db);
});

/// Provider for credit and debit cards repository coordinator.
final cardRepositoryProvider = Provider<CardRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CardRepository(db.cardDao, db);
});

/// Provider for custom and system categories repository coordinator.
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CategoryRepository(db.categoryDao, db);
});

/// Provider for loan debts repository coordinator.
final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LoanRepository(db.loanDao, db);
});

/// Provider for merchant maps repository coordinator.
final merchantMappingRepositoryProvider = Provider<MerchantMappingRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return MerchantMappingRepository(db.merchantMappingDao);
});

/// Provider for profiles repository coordinator.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProfileRepository(db.profileDao);
});

/// Provider for parsing rules repository coordinator.
final ruleRepositoryProvider = Provider<RuleRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return RuleRepository(db.ruleDao, db.ruleApplicationDao);
});

/// Provider for transaction groups repository coordinator.
final transactionGroupRepositoryProvider = Provider<TransactionGroupRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionGroupRepository(db.transactionGroupDao);
});

/// Provider for failed parsing SMS events repository coordinator.
final unrecognizedSmsRepositoryProvider = Provider<UnrecognizedSmsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return UnrecognizedSmsRepository(db.unrecognizedSmsDao);
});

/// Provider for system alerts notification repository coordinator.
final bankNotificationRepositoryProvider = Provider<BankNotificationRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BankNotificationRepository(db.bankNotificationDao);
});

/// Provider for category budget limit repository coordinator.
final budgetGroupRepositoryProvider = Provider<BudgetGroupRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BudgetGroupRepository(db.budgetDao);
});

/// Provider for device biometric screen lock repository coordinator.
final appLockRepositoryProvider = Provider<AppLockRepository>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return AppLockRepository(prefs);
});

/// Provider for LLM chatbot system prompt repository.
final llmRepositoryProvider = Provider<LlmRepository>((ref) {
  return const LlmRepository();
});

/// Provider for AI models metadata.
final modelRepositoryProvider = Provider<ModelRepository>((ref) {
  return const ModelRepository();
});

/// Provider for prompt context assembler repository.
final aiContextRepositoryProvider = Provider<AiContextRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AiContextRepository(db);
});
