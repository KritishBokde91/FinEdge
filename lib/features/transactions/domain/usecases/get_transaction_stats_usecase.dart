import '../entities/transaction_entity.dart';

/// Computed financial statistics from a list of transactions.
class TransactionStats {
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final double savingsRate; // (income - expenses) / income * 100
  final Map<String, double> categoryTotals; // category → total spend
  final Map<String, double> merchantTotals; // merchant → total spend
  final List<MapEntry<String, double>> topCategories; // sorted desc
  final List<MapEntry<String, double>> topMerchants; // sorted desc
  final int transactionCount;

  const TransactionStats({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    required this.savingsRate,
    required this.categoryTotals,
    required this.merchantTotals,
    required this.topCategories,
    required this.topMerchants,
    required this.transactionCount,
  });

  static const empty = TransactionStats(
    totalIncome: 0,
    totalExpenses: 0,
    netBalance: 0,
    savingsRate: 0,
    categoryTotals: {},
    merchantTotals: {},
    topCategories: [],
    topMerchants: [],
    transactionCount: 0,
  );
}

/// Computes aggregate financial statistics from a list of [TransactionEntity].
///
/// Ported from PennyWise's analytics layer: calculates income/expense totals,
/// per-category spend, per-merchant spend, savings rate, and top-N rankings.
class GetTransactionStatsUseCase {
  const GetTransactionStatsUseCase();

  /// Execute on a list of transactions (may be pre-filtered by month/date range).
  TransactionStats execute(List<TransactionEntity> transactions) {
    if (transactions.isEmpty) return TransactionStats.empty;

    double totalIncome = 0;
    double totalExpenses = 0;
    final Map<String, double> categoryTotals = {};
    final Map<String, double> merchantTotals = {};

    for (final tx in transactions) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
        // Credit transactions don't count toward category expenses
      } else {
        totalExpenses += tx.amount;
        // Aggregate by category (expenses only)
        categoryTotals[tx.category] =
            (categoryTotals[tx.category] ?? 0) + tx.amount;
        // Aggregate by merchant (expenses only)
        merchantTotals[tx.merchant] =
            (merchantTotals[tx.merchant] ?? 0) + tx.amount;
      }
    }

    final netBalance = totalIncome - totalExpenses;
    final savingsRate = totalIncome > 0
        ? ((totalIncome - totalExpenses) / totalIncome * 100).clamp(0, 100).toDouble()
        : 0.0;

    // Sort categories and merchants by total descending
    final topCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topMerchants = merchantTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return TransactionStats(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netBalance: netBalance,
      savingsRate: savingsRate,
      categoryTotals: categoryTotals,
      merchantTotals: merchantTotals,
      topCategories: topCategories,
      topMerchants: topMerchants,
      transactionCount: transactions.length,
    );
  }

  /// Filter transactions to a specific month/year before computing stats.
  TransactionStats executeForMonth(
    List<TransactionEntity> allTransactions, {
    required int year,
    required int month,
  }) {
    final filtered = allTransactions.where((tx) {
      return tx.timestamp.year == year && tx.timestamp.month == month;
    }).toList();
    return execute(filtered);
  }
}
