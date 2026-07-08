import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/use_case_providers.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/cards/glass_card.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  int _selectedMonth = DateTime.now().month;
  final int _selectedYear = DateTime.now().year;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // Category icon map
  static const Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Transport': Icons.directions_car_rounded,
    'Entertainment': Icons.movie_rounded,
    'Bills': Icons.receipt_long_rounded,
    'Investment': Icons.trending_up_rounded,
    'Salary': Icons.account_balance_wallet_rounded,
    'Recharge': Icons.smartphone_rounded,
    'Transfer': Icons.swap_horiz_rounded,
    'Cash': Icons.money_rounded,
    'Other': Icons.more_horiz_rounded,
  };

  static const Map<String, Color> _categoryColors = {
    'Food': Color(0xFFFF6B6B),
    'Shopping': Color(0xFF4ECDC4),
    'Transport': Color(0xFF45B7D1),
    'Entertainment': Color(0xFFAE8BF5),
    'Bills': Color(0xFFFFA652),
    'Investment': Color(0xFF2ECC71),
    'Salary': Color(0xFF27AE60),
    'Recharge': Color(0xFF3498DB),
    'Transfer': Color(0xFF95A5A6),
    'Cash': Color(0xFFE67E22),
    'Other': Color(0xFF7F8C8D),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFmt = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 0);
    final txRepo = ref.watch(transactionRepositoryProvider);
    final statsUseCase = ref.watch(getTransactionStatsUseCaseProvider);

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: txRepo.watchAllTransactions(),
          builder: (context, snapshot) {
            final allTx = snapshot.data ?? [];
            final stats = statsUseCase.executeForMonth(
              allTx,
              year: _selectedYear,
              month: _selectedMonth,
            );

            return CustomScrollView(
              slivers: [
                // ── Header ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
                    ),
                    child: Text(
                      'Financial Analytics',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ── Month Scroller ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        itemCount: _months.length,
                        itemBuilder: (context, index) {
                          final isSelected = index + 1 == _selectedMonth;
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _selectedMonth = index + 1,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.cardColor,
                                    borderRadius: AppRadius.borderCircular,
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.dividerColor,
                                    ),
                                  ),
                                  child: Text(
                                    _months[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : theme.hintColor,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ── Summary Hero Cards ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: GlassCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            theme,
                            label: 'Income',
                            amount: currencyFmt.format(stats.totalIncome),
                            icon: Icons.arrow_downward_rounded,
                            color: AppColors.success,
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Colors.white24, height: 1),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            theme,
                            label: 'Expenses',
                            amount: currencyFmt.format(stats.totalExpenses),
                            icon: Icons.arrow_upward_rounded,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Colors.white24, height: 1),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            theme,
                            label: 'Net Savings',
                            amount: currencyFmt.format(stats.netBalance),
                            icon: Icons.savings_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          // Savings Rate Bar
                          ClipRRect(
                            borderRadius: AppRadius.borderCircular,
                            child: LinearProgressIndicator(
                              value: (stats.savingsRate / 100).clamp(0, 1),
                              minHeight: 8,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.success,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Savings Rate: ${stats.savingsRate.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: AppSpacing.h24),

                // ── Category Breakdown ──
                if (stats.topCategories.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(
                        'Spending by Category',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: AppSpacing.h12),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = stats.topCategories[index];
                        final category = entry.key;
                        final amount = entry.value;
                        final ratio = stats.totalExpenses > 0
                            ? amount / stats.totalExpenses
                            : 0.0;
                        final color = _categoryColors[category] ??
                            AppColors.primaryDark;
                        final icon = _categoryIcons[category] ??
                            Icons.category_rounded;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.xs,
                          ),
                          child: _CategoryBar(
                            icon: icon,
                            category: category,
                            amount: amount,
                            amountText: currencyFmt.format(amount),
                            ratio: ratio,
                            color: color,
                            theme: theme,
                          ),
                        );
                      },
                      childCount: stats.topCategories.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: AppSpacing.h24),
                ],

                // ── Top Merchants ──
                if (stats.topMerchants.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(
                        'Top Merchants',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: AppSpacing.h12),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry =
                            stats.topMerchants.take(5).toList()[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.xs,
                          ),
                          child: _MerchantRow(
                            rank: index + 1,
                            merchant: entry.key,
                            amountText: currencyFmt.format(entry.value),
                            theme: theme,
                          ),
                        );
                      },
                      childCount: stats.topMerchants.take(5).length,
                    ),
                  ),
                ],

                // Empty state
                if (stats.transactionCount == 0)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            size: 64,
                            color: theme.hintColor,
                          ),
                          AppSpacing.h16,
                          Text(
                            'No data for ${_months[_selectedMonth - 1]} $_selectedYear',
                            style: TextStyle(color: theme.hintColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    ThemeData theme, {
    required String label,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final IconData icon;
  final String category;
  final double amount;
  final String amountText;
  final double ratio;
  final Color color;
  final ThemeData theme;

  const _CategoryBar({
    required this.icon,
    required this.category,
    required this.amount,
    required this.amountText,
    required this.ratio,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          amountText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: AppRadius.borderCircular,
                      child: LinearProgressIndicator(
                        value: ratio.clamp(0, 1),
                        minHeight: 6,
                        backgroundColor: color.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(ratio * 100).toStringAsFixed(1)}% of total spend',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MerchantRow extends StatelessWidget {
  final int rank;
  final String merchant;
  final String amountText;
  final ThemeData theme;

  const _MerchantRow({
    required this.rank,
    required this.merchant,
    required this.amountText,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              merchant,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            amountText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
