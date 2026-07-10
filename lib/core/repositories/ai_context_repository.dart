import 'package:drift/drift.dart';
import '../../features/ai_assistant/domain/entities/chat_context.dart';
import '../database/drift_database.dart';

/// Repository compiling user prompt data context for the AI assistant chatbot.
///
/// Ported from AiContextRepository.kt.
class AiContextRepository {
  final AppDatabase _db;

  const AiContextRepository(this._db);

  /// Queries Drift database tables to build month summaries, category totals, and active subscriptions.
  Future<ChatContext> getChatContext() async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    // 1. Fetch current month transactions
    final query = _db.select(_db.transactionsTable)
      ..where((t) => t.timestamp.isBiggerOrEqualValue(firstDayOfMonth));
    final txs = await query.get();

    double totalIncome = 0.0;
    double totalExpense = 0.0;
    for (final tx in txs) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
      }
    }

    // 2. Fetch category totals breakdown
    final categoryTotals = <String, double>{};
    for (final tx in txs) {
      categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0.0) + tx.amount;
    }

    final topCategories = categoryTotals.entries.map((e) {
      final total = totalIncome + totalExpense;
      final pct = total > 0 ? (e.value / total) * 100 : 0.0;
      return CategorySpending(
        category: e.key,
        amount: e.value,
        percentage: pct,
        transactionCount: txs.where((t) => t.category == e.key).length,
      );
    }).toList();

    // 3. Fetch active subscriptions billing schedules
    final subs = await _db.select(_db.subscriptionsTable).get();
    final activeSubs = subs.map((s) {
      final diff = s.nextBillingDate.difference(DateTime.now()).inDays;
      return SubscriptionSummary(
        merchantName: s.merchant,
        amount: s.amount,
        nextPaymentDays: diff < 0 ? 0 : diff,
      );
    }).toList();

    // 4. Build MonthSummary metrics
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final monthSummary = MonthSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      transactionCount: txs.length,
      daysInMonth: daysInMonth,
      currentDay: now.day,
    );

    // 5. Build QuickStats aggregates
    final avgDaily = now.day > 0 ? totalExpense / now.day : 0.0;
    TransactionsTableData? largestTx;
    if (txs.isNotEmpty) {
      largestTx = txs.reduce((curr, next) => curr.amount > next.amount ? curr : next);
    }

    TransactionSummary? largestSummary;
    if (largestTx != null) {
      largestSummary = TransactionSummary(
        merchantName: largestTx.merchant,
        amount: largestTx.amount,
        category: largestTx.category,
        daysAgo: now.difference(largestTx.timestamp).inDays,
        dateTime: largestTx.timestamp,
        transactionType: largestTx.isIncome ? 'INCOME' : 'EXPENSE',
      );
    }

    final quickStats = QuickStats(
      avgDailySpending: avgDaily,
      largestExpenseThisMonth: largestSummary,
      mostFrequentMerchant: null,
      mostFrequentMerchantCount: 0,
    );

    return ChatContext(
      currentDate: now,
      monthSummary: monthSummary,
      recentTransactions: txs.take(5).map((t) {
        return TransactionSummary(
          merchantName: t.merchant,
          amount: t.amount,
          category: t.category,
          daysAgo: now.difference(t.timestamp).inDays,
          dateTime: t.timestamp,
          transactionType: t.isIncome ? 'INCOME' : 'EXPENSE',
        );
      }).toList(),
      activeSubscriptions: activeSubs,
      topCategories: topCategories,
      quickStats: quickStats,
    );
  }
}
