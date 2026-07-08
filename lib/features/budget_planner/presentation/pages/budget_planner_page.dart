import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../core/di/use_case_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/budget/budget_progress_indicator.dart';
import '../../../budget_planner/domain/entities/budget_entity.dart';
import '../../../budget_planner/domain/usecases/manage_budget_usecase.dart';

class BudgetPlannerPage extends ConsumerStatefulWidget {
  const BudgetPlannerPage({super.key});

  @override
  ConsumerState<BudgetPlannerPage> createState() => _BudgetPlannerPageState();
}

class _BudgetPlannerPageState extends ConsumerState<BudgetPlannerPage> {
  static const List<String> _availableCategories = [
    'Food', 'Shopping', 'Transport', 'Entertainment',
    'Bills', 'Investment', 'Recharge', 'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final budgetUseCase = ref.watch(manageBudgetUseCaseProvider);
    final txRepo = ref.watch(transactionRepositoryProvider);
    final currencyFmt = NumberFormat.simpleCurrency(
      name: 'INR', decimalDigits: 0,
    );

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<BudgetEntity>>(
          stream: budgetUseCase.watchBudgets(),
          builder: (context, budgetSnapshot) {
            return StreamBuilder(
              stream: txRepo.watchAllTransactions(),
              builder: (context, txSnapshot) {
                final budgets = budgetSnapshot.data ?? [];
                final transactions = txSnapshot.data ?? [];
                final (periodStart, periodEnd) =
                    ManageBudgetUseCase.currentMonthPeriod();

                return CustomScrollView(
                  slivers: [
                    // ── Header ──
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Budget Planner',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('MMMM yyyy').format(DateTime.now()),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariantDark,
                                  ),
                                ),
                              ],
                            ),
                            FilledButton.tonal(
                              onPressed: () => _showAddBudgetSheet(
                                context,
                                budgetUseCase,
                                periodStart,
                                periodEnd,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 18),
                                  SizedBox(width: 4),
                                  Text('Add Budget'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Budget Cards ──
                    if (budgets.isEmpty)
                      SliverFillRemaining(
                        child: _EmptyBudgetState(
                          onAdd: () => _showAddBudgetSheet(
                            context,
                            budgetUseCase,
                            periodStart,
                            periodEnd,
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final budget = budgets[index];
                            final spent = ManageBudgetUseCase.calculateSpending(
                              category: budget.category,
                              startDate: budget.startDate,
                              endDate: budget.endDate,
                              allTransactions: transactions,
                            );
                            final ratio = ManageBudgetUseCase.utilisationRatio(
                              spent: spent,
                              limit: budget.limitAmount,
                            );

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                              child: _BudgetCard(
                                budget: budget,
                                spent: spent,
                                ratio: ratio,
                                currencyFmt: currencyFmt,
                                theme: theme,
                                onDelete: () async {
                                  await budgetUseCase.deleteBudget(budget.id);
                                },
                              ),
                            );
                          },
                          childCount: budgets.length,
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showAddBudgetSheet(
    BuildContext context,
    ManageBudgetUseCase useCase,
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddBudgetSheet(
        useCase: useCase,
        categories: _availableCategories,
        periodStart: periodStart,
        periodEnd: periodEnd,
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetEntity budget;
  final double spent;
  final double ratio;
  final NumberFormat currencyFmt;
  final ThemeData theme;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.spent,
    required this.ratio,
    required this.currencyFmt,
    required this.theme,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOverspent = ratio >= 1.0;
    final isWarning = ratio >= 0.8 && !isOverspent;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: isOverspent
              ? AppColors.error.withOpacity(0.5)
              : isWarning
                  ? AppColors.warning.withOpacity(0.5)
                  : theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                budget.category,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  if (isOverspent)
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 18,
                    )
                  else if (isWarning)
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.warning,
                      size: 18,
                    ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 20),
                    color: theme.hintColor,
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.h8,
          BudgetProgressIndicator(limit: budget.limitAmount, spent: spent),
          AppSpacing.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ${currencyFmt.format(spent)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isOverspent
                      ? AppColors.error
                      : theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Limit: ${currencyFmt.format(budget.limitAmount)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                ),
              ),
            ],
          ),
          if (isOverspent) ...[
            AppSpacing.h4,
            Text(
              'Over by ${currencyFmt.format(spent - budget.limitAmount)}',
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddBudgetSheet extends ConsumerStatefulWidget {
  final ManageBudgetUseCase useCase;
  final List<String> categories;
  final DateTime periodStart;
  final DateTime periodEnd;

  const _AddBudgetSheet({
    required this.useCase,
    required this.categories,
    required this.periodStart,
    required this.periodEnd,
  });

  @override
  ConsumerState<_AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends ConsumerState<_AddBudgetSheet> {
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: AppRadius.borderCircular,
              ),
            ),
          ),
          AppSpacing.h16,
          Text(
            'Set Budget Limit',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.h4,
          Text(
            DateFormat('MMMM yyyy').format(DateTime.now()),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariantDark,
            ),
          ),
          AppSpacing.h24,
          // Category Dropdown
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(
                borderRadius: AppRadius.borderMd,
              ),
            ),
            items: widget.categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _selectedCategory = v!),
          ),
          AppSpacing.h16,
          // Amount Field
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Budget Limit (₹)',
              border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
              prefixText: '₹ ',
            ),
          ),
          if (_errorMsg != null) ...[
            AppSpacing.h8,
            Text(
              _errorMsg!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ],
          AppSpacing.h24,
          FilledButton(
            onPressed: _isLoading ? null : _submit,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Save Budget'),
          ),
          AppSpacing.h16,
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText.replaceAll(',', ''));

    if (amount == null || amount <= 0) {
      setState(() => _errorMsg = 'Enter a valid budget amount');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    await widget.useCase.createBudget(
      category: _selectedCategory,
      limitAmount: amount,
      startDate: widget.periodStart,
      endDate: widget.periodEnd,
    );

    if (mounted) Navigator.pop(context);
  }
}

class _EmptyBudgetState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyBudgetState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 72,
            color: Theme.of(context).hintColor,
          ),
          AppSpacing.h16,
          Text(
            'No budgets set',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          AppSpacing.h8,
          const Text(
            'Set spending limits for your categories\nto stay on track.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurfaceVariantDark,
              fontSize: 13,
            ),
          ),
          AppSpacing.h24,
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Create Your First Budget'),
          ),
        ],
      ),
    );
  }
}
