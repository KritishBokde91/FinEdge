import 'package:flutter_test/flutter_test.dart';
import 'package:finsight_ai/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finsight_ai/features/budget_planner/domain/entities/budget_entity.dart';
import 'package:finsight_ai/features/financial_goals/domain/entities/goal_entity.dart';
import 'package:finsight_ai/features/ai_assistant/domain/services/ai_coach_engine.dart';

void main() {
  const engine = AiCoachEngine();

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

    test('Should analyze spending query and return correct totals', () {
      final response = engine.processQuery(
        query: 'How much did I spend this month?',
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );

      expect(response, contains(' spent a total of '));
      expect(response, contains('3,500')); // total expenses = 2000 + 1500
      expect(response, contains('Shopping')); // top category
    });

    test('Should analyze income query and return totals', () {
      final response = engine.processQuery(
        query: 'What is my total income?',
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );

      expect(response, contains('recorded'));
      expect(response, contains('50,000'));
    });

    test('Should return monthly budget status', () {
      final response = engine.processQuery(
        query: 'Show my budgets status',
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );

      expect(response, contains('Food'));
      expect(response, contains('1,500 /'));
      expect(response, contains('5,000'));
    });

    test('Should return savings goals progress', () {
      final response = engine.processQuery(
        query: 'Goals status',
        transactions: mockTransactions,
        budgets: mockBudgets,
        goals: mockGoals,
      );

      expect(response, contains('Emergency Fund'));
      expect(response, contains('25,000 of'));
      expect(response, contains('100,000'));
    });
  });
}
