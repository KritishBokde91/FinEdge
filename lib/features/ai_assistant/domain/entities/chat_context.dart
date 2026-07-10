/// Month summary metrics for AI chat context.
class MonthSummary {
  final double totalIncome;
  final double totalExpense;
  final int transactionCount;
  final int daysInMonth;
  final int currentDay;

  const MonthSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.transactionCount,
    required this.daysInMonth,
    required this.currentDay,
  });
}

/// Transaction details summary.
class TransactionSummary {
  final String merchantName;
  final double amount;
  final String category;
  final int daysAgo;
  final DateTime dateTime;
  final String transactionType; // e.g. INCOME, EXPENSE

  const TransactionSummary({
    required this.merchantName,
    required this.amount,
    required this.category,
    required this.daysAgo,
    required this.dateTime,
    required this.transactionType,
  });
}

/// Active subscription detail.
class SubscriptionSummary {
  final String merchantName;
  final double amount;
  final int nextPaymentDays;

  const SubscriptionSummary({
    required this.merchantName,
    required this.amount,
    required this.nextPaymentDays,
  });
}

/// Category spending stats.
class CategorySpending {
  final String category;
  final double amount;
  final double percentage;
  final int transactionCount;

  const CategorySpending({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.transactionCount,
  });
}

/// Quick stats analytics metrics.
class QuickStats {
  final double avgDailySpending;
  final TransactionSummary? largestExpenseThisMonth;
  final String? mostFrequentMerchant;
  final int mostFrequentMerchantCount;

  const QuickStats({
    required this.avgDailySpending,
    required this.largestExpenseThisMonth,
    required this.mostFrequentMerchant,
    required this.mostFrequentMerchantCount,
  });
}

/// Complete chat context state payload sent to LLM prompt engine.
///
/// Ported from ChatContext.kt.
class ChatContext {
  final DateTime currentDate;
  final MonthSummary monthSummary;
  final List<TransactionSummary> recentTransactions;
  final List<SubscriptionSummary> activeSubscriptions;
  final List<CategorySpending> topCategories;
  final QuickStats quickStats;

  const ChatContext({
    required this.currentDate,
    required this.monthSummary,
    required this.recentTransactions,
    required this.activeSubscriptions,
    required this.topCategories,
    required this.quickStats,
  });
}
