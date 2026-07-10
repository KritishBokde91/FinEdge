import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/use_case_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../financial_goals/domain/entities/goal_entity.dart';
import '../../../financial_goals/domain/usecases/manage_goal_usecase.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  static const List<String> _availableCategories = [
    'Emergency Fund',
    'Vacation',
    'Car',
    'Home',
    'Education',
    'Retirement',
    'Investment',
    'Wedding',
    'Electronics',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final useCase = ref.watch(manageGoalUseCaseProvider);
    final currencyFmt = NumberFormat.simpleCurrency(
      name: 'INR',
      decimalDigits: 0,
    );

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<GoalEntity>>(
          stream: useCase.watchGoals(),
          builder: (context, snapshot) {
            final goals = snapshot.data ?? [];
            final progresses = goals.map(useCase.computeProgress).toList();

            return CustomScrollView(
              slivers: [
                // ── Header ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Financial Goals',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FilledButton.tonal(
                          onPressed: () => _showAddGoalSheet(context, useCase),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 18),
                              SizedBox(width: 4),
                              Text('Add Goal'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Summary strip ──
                if (goals.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: _GoalSummaryStrip(
                        total: goals.length,
                        completed: progresses
                            .where((p) => p.isCompleted)
                            .length,
                        theme: theme,
                      ),
                    ),
                  ),

                // ── Goals List ──
                if (goals.isEmpty)
                  SliverFillRemaining(
                    child: _EmptyGoalsState(
                      onAdd: () => _showAddGoalSheet(context, useCase),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final progress = progresses[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        child: _GoalCard(
                          progress: progress,
                          currencyFmt: currencyFmt,
                          theme: theme,
                          onDelete: () => useCase.deleteGoal(progress.goal.id),
                          onAddFunds: () => _showAddFundsSheet(
                            context,
                            useCase,
                            progress.goal,
                            currencyFmt,
                          ),
                        ),
                      );
                    }, childCount: progresses.length),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context, ManageGoalUseCase useCase) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          _AddGoalSheet(useCase: useCase, categories: _availableCategories),
    );
  }

  void _showAddFundsSheet(
    BuildContext context,
    ManageGoalUseCase useCase,
    GoalEntity goal,
    NumberFormat fmt,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddFundsSheet(useCase: useCase, goal: goal, fmt: fmt),
    );
  }
}

class _GoalSummaryStrip extends StatelessWidget {
  final int total;
  final int completed;
  final ThemeData theme;
  const _GoalSummaryStrip({
    required this.total,
    required this.completed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Total Goals', value: '$total', theme: theme),
          _Stat(label: 'Completed', value: '$completed', theme: theme),
          _Stat(
            label: 'In Progress',
            value: '${total - completed}',
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  const _Stat({required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final GoalProgress progress;
  final NumberFormat currencyFmt;
  final ThemeData theme;
  final VoidCallback onDelete;
  final VoidCallback onAddFunds;

  const _GoalCard({
    required this.progress,
    required this.currencyFmt,
    required this.theme,
    required this.onDelete,
    required this.onAddFunds,
  });

  @override
  Widget build(BuildContext context) {
    final goal = progress.goal;
    final pct = (progress.progressRatio * 100).clamp(0, 100).toStringAsFixed(0);
    final progressColor = progress.isCompleted
        ? AppColors.success
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: progress.isCompleted
              ? AppColors.success.withOpacity(0.5)
              : theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      goal.category,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (progress.isCompleted)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
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
          AppSpacing.h12,
          ClipRRect(
            borderRadius: AppRadius.borderCircular,
            child: LinearProgressIndicator(
              value: progress.progressRatio.clamp(0, 1),
              minHeight: 8,
              backgroundColor: progressColor.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          AppSpacing.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currencyFmt.format(goal.currentAmount)} saved',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: progressColor,
                ),
              ),
              Text(
                'Target: ${currencyFmt.format(goal.targetAmount)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.h4,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$pct% complete',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (progress.daysRemaining != null)
                Text(
                  '${progress.daysRemaining} days left',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: progress.daysRemaining! <= 7
                        ? AppColors.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                Text(
                  '${currencyFmt.format(progress.remainingAmount)} remaining',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          if (!progress.isCompleted) ...[
            AppSpacing.h12,
            OutlinedButton.icon(
              onPressed: onAddFunds,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Funds'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(36),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddGoalSheet extends ConsumerStatefulWidget {
  final ManageGoalUseCase useCase;
  final List<String> categories;
  const _AddGoalSheet({required this.useCase, required this.categories});

  @override
  ConsumerState<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<_AddGoalSheet> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _currentController = TextEditingController();
  String _selectedCategory = 'Vacation';
  DateTime _targetDate = DateTime.now().add(const Duration(days: 365));
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _currentController.dispose();
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
      child: SingleChildScrollView(
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
              'Create Financial Goal',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.h24,
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                hintText: 'e.g., Emergency Fund',
              ),
            ),
            AppSpacing.h16,
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
              ),
              items: widget.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            AppSpacing.h16,
            TextField(
              controller: _targetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Target Amount (₹)',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                prefixText: '₹ ',
              ),
            ),
            AppSpacing.h16,
            TextField(
              controller: _currentController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount Already Saved (₹)',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                prefixText: '₹ ',
                hintText: '0',
              ),
            ),
            AppSpacing.h16,
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Target Date'),
              subtitle: Text(
                DateFormat('d MMMM yyyy').format(_targetDate),
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              trailing: const Icon(Icons.calendar_today_rounded),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _targetDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                );
                if (picked != null) setState(() => _targetDate = picked);
              },
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
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Create Goal'),
            ),
            AppSpacing.h16,
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final target = double.tryParse(
      _targetController.text.trim().replaceAll(',', ''),
    );
    final current =
        double.tryParse(_currentController.text.trim().replaceAll(',', '')) ??
        0.0;

    if (title.isEmpty) {
      setState(() => _errorMsg = 'Please enter a goal title');
      return;
    }
    if (target == null || target <= 0) {
      setState(() => _errorMsg = 'Enter a valid target amount');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    await widget.useCase.createGoal(
      title: title,
      targetAmount: target,
      currentAmount: current,
      targetDate: _targetDate,
      category: _selectedCategory,
    );

    if (mounted) Navigator.pop(context);
  }
}

class _AddFundsSheet extends ConsumerStatefulWidget {
  final ManageGoalUseCase useCase;
  final GoalEntity goal;
  final NumberFormat fmt;
  const _AddFundsSheet({
    required this.useCase,
    required this.goal,
    required this.fmt,
  });

  @override
  ConsumerState<_AddFundsSheet> createState() => _AddFundsSheetState();
}

class _AddFundsSheetState extends ConsumerState<_AddFundsSheet> {
  final _amountController = TextEditingController();
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
            'Add Funds to "${widget.goal.title}"',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.h8,
          Text(
            'Currently saved: ${widget.fmt.format(widget.goal.currentAmount)} / ${widget.fmt.format(widget.goal.targetAmount)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.h24,
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Amount to Add (₹)',
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
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Add Funds'),
          ),
          AppSpacing.h16,
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', ''),
    );
    if (amount == null || amount <= 0) {
      setState(() => _errorMsg = 'Enter a valid amount');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    await widget.useCase.updateGoalProgress(widget.goal, amount);
    if (mounted) Navigator.pop(context);
  }
}

class _EmptyGoalsState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyGoalsState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 72,
            color: Theme.of(context).hintColor,
          ),
          AppSpacing.h16,
          Text(
            'No goals yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          AppSpacing.h8,
          Text(
            'Set financial goals to track your\nprogress toward what matters most.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          AppSpacing.h24,
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Create Your First Goal'),
          ),
        ],
      ),
    );
  }
}
