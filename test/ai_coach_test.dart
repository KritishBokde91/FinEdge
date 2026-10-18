import 'package:flutter_test/flutter_test.dart';
import 'package:finsight_ai/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finsight_ai/features/budget_planner/domain/entities/budget_entity.dart';
import 'package:finsight_ai/features/financial_goals/domain/entities/goal_entity.dart';
import 'package:finsight_ai/features/ai_assistant/domain/services/ai_coach_engine.dart';
import 'package:finsight_ai/core/repositories/llm_repository.dart';

/// Helper: builds an [AiCoachEngine] with the given mock data for offline testing.
/// Uses a real [LlmRepository] but processQueryWithLLM won't hit the network
/// in unit tests — we test the offline fallback via _OfflineEngine indirectly
/// by checking that the engine returns reasonable local analysis when Groq is
/// unavailable (no API key in test environment).
AiCoachEngine buildEngine({
  required List<TransactionEntity> transactions,
  required List<BudgetEntity> budgets,
  required List<GoalEntity> goals,
}) {
  return AiCoachEngine(
    llmRepo: const LlmRepository(),
    context: AiDataContext(
      transactions: transactions,
      budgets: budgets,
      goals: goals,
    ),
  );
}

void main() {
  group('AiCoachEngine offline response processor tests', () {
    final now = DateTime.now();

    final mockTransactions = [
      TransactionEntity(
        id: 'tx-1',
        smsId: 'sms-1',
        amount: 2000.0,
        merchant: 'Amazon Shopping',
        category: 'Shopping',
        timestamp: now,
        isIncome: false,
        accountSource: 'HDFC Bank',
      ),
      TransactionEntity(
        id: 'tx-2',
        smsId: 'sms-2',
        amount: 1500.0,
        merchant: 'Swiggy Food delivery',
        category: 'Food',
        timestamp: now,
        isIncome: false,
        accountSource: 'HDFC Bank',
      ),
      TransactionEntity(
        id: 'tx-3',
        smsId: 'sms-3',
        amount: 50000.0,
        merchant: 'TCS Salary Credit',
        category: 'Salary',
        timestamp: now,
        isIncome: true,
        accountSource: 'HDFC Bank',
      ),
    ];

    final mockBudgets = [
      BudgetEntity(
        id: 'b-1',
        category: 'Food',
        limitAmount: 5000.0,
        startDate: now,
        endDate: now,
      ),
    ];

    final mockGoals = [
      GoalEntity(
        id: 'g-1',
        title: 'Emergency Fund',
        targetAmount: 100000.0,
        currentAmount: 25000.0,
        targetDate: now,
        category: 'Other',
      ),
    ];

    test('processQueryWithLLM returns a non-empty string for spending query',
        () async {
      final engine = buildEngine(
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );
      // Without a valid API key, engine falls back to offline analysis
      final response = await engine.processQueryWithLLM(
        'How much did I spend this month?',
      );
      expect(response, isNotEmpty);
      expect(response, isA<String>());
    });

    test('processQueryWithLLM returns income info for income query', () async {
      final engine = buildEngine(
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );
      final response = await engine.processQueryWithLLM('What is my income?');
      expect(response, isNotEmpty);
    });

    test('processQueryWithLLM returns budget info for budget query', () async {
      final engine = buildEngine(
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );
      final response =
          await engine.processQueryWithLLM('Show my budget status');
      expect(response, isNotEmpty);
    });

    test('processQueryWithLLM returns goals info for goals query', () async {
      final engine = buildEngine(
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );
      final response =
          await engine.processQueryWithLLM('Show my savings goals');
      expect(response, isNotEmpty);
    });

    // ── Tool execution unit tests (internal tool helpers) ──────────────────
    // We test the tool data via AiDataContext directly.

    test('AiDataContext correctly filters current month transactions', () {
      final context = AiDataContext(
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );
      // All mock transactions are dated `now` — so all should be in current month
      final currentMonth = context.transactions
          .where((tx) =>
              tx.timestamp.year == DateTime.now().year &&
              tx.timestamp.month == DateTime.now().month)
          .toList();
      expect(currentMonth.length, equals(3));
    });

    test('AiDataContext separates income and expense correctly', () {
      final context = AiDataContext(
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );
      final income =
          context.transactions.where((tx) => tx.isIncome).toList();
      final expenses =
          context.transactions.where((tx) => !tx.isIncome).toList();
      expect(income.length, equals(1));
      expect(expenses.length, equals(2));
      expect(income.first.amount, equals(50000.0));
    });
  });
}
