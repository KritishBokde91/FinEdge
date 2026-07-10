import 'package:intl/intl.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../budget_planner/domain/entities/budget_entity.dart';
import '../../../financial_goals/domain/entities/goal_entity.dart';

class AiCoachEngine {
  const AiCoachEngine();

  String processQuery({
    required String query,
    required List<TransactionEntity> transactions,
    required List<BudgetEntity> budgets,
    required List<GoalEntity> goals,
  }) {
    final normalized = query.toLowerCase();
    final currencyFmt = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 0);

    final now = DateTime.now();
    final currentMonthTx = transactions.where((tx) =>
        tx.timestamp.year == now.year && tx.timestamp.month == now.month).toList();

    double totalIncome = 0;
    double totalExpenses = 0;
    final Map<String, double> categoryExpenses = {};

    for (final tx in currentMonthTx) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
      } else {
        totalExpenses += tx.amount;
        categoryExpenses[tx.category] = (categoryExpenses[tx.category] ?? 0) + tx.amount;
      }
    }

    String topCategory = 'None';
    double topCategoryAmount = 0;
    if (categoryExpenses.isNotEmpty) {
      final sorted = categoryExpenses.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      topCategory = sorted.first.key;
      topCategoryAmount = sorted.first.value;
    }

    final balance = totalIncome - totalExpenses;

    // 1. Spending queries
    if (normalized.contains('spend') ||
        normalized.contains('spent') ||
        normalized.contains('expense') ||
        normalized.contains('outflow')) {
      if (totalExpenses == 0) {
        return 'You have not recorded any expenses this month yet! Pull to refresh on the dashboard to import new SMS messages.';
      }
      return 'You have spent a total of ${currencyFmt.format(totalExpenses)} this month.\n\nYour highest spending category is **$topCategory** at ${currencyFmt.format(topCategoryAmount)}.\n\nWould you like a breakdown of other categories?';
    }

    // 2. Income queries
    if (normalized.contains('income') ||
        normalized.contains('earn') ||
        normalized.contains('salary') ||
        normalized.contains('received')) {
      if (totalIncome == 0) {
        return "I couldn't find any income transactions recorded for this month. If you received salary, make sure the SMS is scanned or add a manual transaction.";
      }
      return 'You have recorded ${currencyFmt.format(totalIncome)} in income this month. With expenses at ${currencyFmt.format(totalExpenses)}, your net savings are ${currencyFmt.format(balance)}.';
    }

    // 3. Budget queries
    if (normalized.contains('budget')) {
      if (budgets.isEmpty) {
        return 'You don\'t have any budgets set up yet. Go to the **Budgets** section to set monthly targets for categories like Food, Shopping, or Bills!';
      }
      final buffer = StringBuffer('Here is your budget status:\n');
      for (final budget in budgets) {
        final categorySpend = categoryExpenses[budget.category] ?? 0.0;
        final percent = (categorySpend / budget.limitAmount * 100).toStringAsFixed(0);
        buffer.write('\n• **${budget.category}**: ${currencyFmt.format(categorySpend)} / ${currencyFmt.format(budget.limitAmount)} ($percent%)');
        if (categorySpend > budget.limitAmount) {
          buffer.write(' ⚠️ OVER BUDGET!');
        }
      }
      return buffer.toString();
    }

    // 4. Goal queries
    if (normalized.contains('goal') || normalized.contains('saving')) {
      if (goals.isEmpty) {
        return 'You haven\'t set any savings goals yet. Setting clear targets (like an Emergency Fund or a Vacation) helps you save consistently. Go to **Goals** to create one!';
      }
      final buffer = StringBuffer('Here is the progress on your savings goals:\n');
      for (final goal in goals) {
        final percent = (goal.currentAmount / goal.targetAmount * 100).toStringAsFixed(0);
        buffer.write('\n• **${goal.title}**: ${currencyFmt.format(goal.currentAmount)} of ${currencyFmt.format(goal.targetAmount)} ($percent%)');
        if (goal.currentAmount >= goal.targetAmount) {
          buffer.write(' 🎉 COMPLETED!');
        }
      }
      return buffer.toString();
    }

    // 5. Summary queries
    if (normalized.contains('summary') ||
        normalized.contains('status') ||
        normalized.contains('financial') ||
        normalized.contains('how am i')) {
      final statusMsg = balance >= 0 
          ? 'You are running a positive cash flow! Keep it up to build your savings.' 
          : "Warning: You are spending more than you earn this month. Let's check your budgets to see where to cut back.";
      return 'Here is your on-device financial summary for **${DateFormat('MMMM yyyy').format(now)}**:\n\n'
          '• **Total Income**: ${currencyFmt.format(totalIncome)}\n'
          '• **Total Expenses**: ${currencyFmt.format(totalExpenses)}\n'
          '• **Net Savings**: ${currencyFmt.format(balance)}\n'
          '• **Top Category**: $topCategory (${currencyFmt.format(topCategoryAmount)})\n\n'
          '$statusMsg';
    }

    // 6. Help queries
    if (normalized.contains('help') || normalized.contains('what can you do')) {
      return 'I can analyze your local financial databases and answer queries offline!\n\nTry asking me:\n'
          '• "How much did I spend this month?"\n'
          '• "Give me a financial summary"\n'
          '• "Check my budget status"\n'
          '• "Show my savings goals progress"';
    }

    // 7. Generic Fallback Coaching Tips
    final tips = [
      'Tip: Pay yourself first! As soon as you receive income, automatically move 10-20% to a separate savings goal or emergency fund.',
      'Tip: Track the small expenses. A daily ₹150 coffee adds up to ₹4,500 a month. Trimming small leaks makes a massive difference over a year.',
      'Tip: Try the 50/30/20 rule! Allocate 50% of your income to Needs (bills, rent), 30% to Wants (dining, hobbies), and 20% to Savings or debt payoff.',
      'Tip: Before making a non-essential purchase over ₹2,000, wait 24 hours. This "cooling off" period eliminates most impulsive shopping!',
    ];

    final randomTip = (tips..shuffle()).first;
    return 'I\'m not sure how to answer that specific question, but I\'m learning! Try asking about your "spending", "income", "budgets", or "savings goals".\n\n💡 **Here is a coaching tip for you:**\n$randomTip';
  }
}
