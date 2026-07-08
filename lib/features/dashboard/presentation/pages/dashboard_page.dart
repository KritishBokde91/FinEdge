import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/cards/glass_card.dart';
import '../../../../shared/widgets/transactions/transaction_tile.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../sms_intelligence/domain/services/sms_sync_service.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Rescan on dashboard load so previous failed parser runs do not hide old SMS.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(smsSyncServiceProvider).syncInbox(forceResync: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txRepository = ref.watch(transactionRepositoryProvider);
    final currencyFormat = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 2);
    final currencyFormatCompact = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 0);

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: txRepository.watchAllTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final transactions = snapshot.data ?? [];

            // Calculate financial metrics dynamically from Drift SQLite
            double totalIncome = 0;
            double totalExpenses = 0;
            for (final tx in transactions) {
              if (tx.isIncome) {
                totalIncome += tx.amount;
              } else {
                totalExpenses += tx.amount;
              }
            }
            final balance = totalIncome - totalExpenses;

            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(smsSyncServiceProvider).syncInbox(forceResync: true),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Greeting Header ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariantDark,
                              ),
                            ),
                            Text(
                              'Kritish',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.12),
                          child: Text(
                            'K',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.h24,

                    // --- Balance Hero Card ---
                    GlassCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL BALANCE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                              letterSpacing: 1.5,
                            ),
                          ),
                          AppSpacing.h8,
                          Text(
                            currencyFormat.format(balance),
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSpacing.h24,
                          Row(
                            children: [
                              Expanded(
                                child: _buildFlowSummary(
                                  icon: Icons.arrow_downward_rounded,
                                  label: 'Income',
                                  amountText: currencyFormatCompact.format(
                                    totalIncome,
                                  ),
                                  iconColor: AppColors.success,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white24,
                              ),
                              Expanded(
                                child: _buildFlowSummary(
                                  icon: Icons.arrow_upward_rounded,
                                  label: 'Expenses',
                                  amountText: currencyFormatCompact.format(
                                    totalExpenses,
                                  ),
                                  iconColor: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.h24,

                    // --- Quick Actions ---
                    Text(
                      'Quick Actions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.h12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickAction(
                          icon: Icons.sync_rounded,
                          label: 'Sync SMS',
                          onTap: () async {
                            final imported = await ref
                                .read(smsSyncServiceProvider)
                                .syncInbox(forceResync: true);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  imported == 1
                                      ? 'Imported 1 transaction.'
                                      : 'Imported $imported transactions.',
                                ),
                              ),
                            );
                          },
                        ),
                        _buildQuickAction(
                          icon: Icons.bar_chart_rounded,
                          label: 'Analytics',
                          onTap: () => context.goNamed(RouteNames.analytics),
                        ),
                        _buildQuickAction(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Budgets',
                          onTap: () {
                            // Sub-routes can be called if implemented
                          },
                        ),
                        _buildQuickAction(
                          icon: Icons.stars_rounded,
                          label: 'Goals',
                          onTap: () {
                            // Sub-routes can be called if implemented
                          },
                        ),
                      ],
                    ),
                    AppSpacing.h24,

                    // --- Trend Chart Section ---
                    Text(
                      'Cash Flow Trend',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.h12,
                    Container(
                      height: 160,
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: AppRadius.borderLg,
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: CustomPaint(painter: _LineChartPainter(transactions)),
                    ),
                    AppSpacing.h24,

                    // --- Recent Transactions ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.goNamed(RouteNames.transactions),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    AppSpacing.h8,
                    if (transactions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xl,
                          ),
                          child: Text(
                            'No recent transactions.',
                            style: TextStyle(color: theme.hintColor),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length > 3
                            ? 3
                            : transactions.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          return TransactionTile(
                            title: tx.merchant,
                            category: tx.category,
                            amount: tx.amount,
                            isIncome: tx.isIncome,
                            date: tx.timestamp,
                            accountSource: tx.accountSource,
                            onTap: () {
                              context.go(
                                '${RouteNames.transactionsPath}/details/${tx.id}',
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlowSummary({
    required IconData icon,
    required String label,
    required String amountText,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: iconColor),
            AppSpacing.w4,
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        AppSpacing.h4,
        Text(
          amountText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton.filledTonal(onPressed: onTap, icon: Icon(icon)),
        AppSpacing.h4,
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<TransactionEntity> transactions;

  _LineChartPainter(this.transactions);

  @override
  void paint(Canvas canvas, Size size) {
    if (transactions.isEmpty) {
      final paint = Paint()
        ..color = AppColors.primaryDark.withOpacity(0.3)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        paint,
      );
      return;
    }

    // Sort transactions chronologically
    final sortedTx = List<TransactionEntity>.from(transactions)
      ..sort((TransactionEntity a, TransactionEntity b) => a.timestamp.compareTo(b.timestamp));

    // Calculate running balance points
    double runningBalance = 0;
    final List<double> balances = [];
    for (final tx in sortedTx) {
      if (tx.isIncome) {
        runningBalance += tx.amount;
      } else {
        runningBalance -= tx.amount;
      }
      balances.add(runningBalance);
    }

    double minBal = balances.reduce((a, b) => a < b ? a : b);
    double maxBal = balances.reduce((a, b) => a > b ? a : b);

    if (maxBal == minBal) {
      maxBal += 100;
      minBal -= 100;
    }
    final range = maxBal - minBal;

    final paint = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [
          AppColors.primaryDark.withOpacity(0.24),
          AppColors.primaryDark.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final double stepX = size.width / (balances.length - 1).clamp(1, double.infinity);

    for (int i = 0; i < balances.length; i++) {
      final x = i * stepX;
      final y = size.height -
          ((balances[i] - minBal) /
                  range *
                  (size.height * 0.8) +
              (size.height * 0.1));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.transactions != transactions;
}
