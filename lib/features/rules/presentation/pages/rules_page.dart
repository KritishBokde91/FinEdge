import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/di/core_repository_providers.dart';
import '../../../../core/di/billing_providers.dart';
import '../../../billing/domain/entities/free_tier_limits.dart';
import '../../domain/entities/transaction_rule.dart';
import '../../domain/entities/rule_condition.dart';
import '../../domain/entities/rule_action.dart';

class RulesPage extends ConsumerStatefulWidget {
  const RulesPage({super.key});

  @override
  ConsumerState<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends ConsumerState<RulesPage> {
  Future<void> _showAddRuleDialog(BuildContext context) async {
    final isPro = ref.read(isProProvider).value ?? false;
    final ruleRepo = ref.read(ruleRepositoryProvider);
    final existingRules = await ruleRepo.getRules();

    if (!isPro && existingRules.length >= FreeTierLimits.maxRules) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Free Tier Limit Reached'),
            content: const Text(
              'Free tier users can create up to ${FreeTierLimits.maxRules} transaction rules. Upgrade to FinSight Pro to unlock unlimited rules and advanced automation.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Maybe Later'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.pushNamed(RouteNames.upgrade);
                },
                child: const Text('Upgrade to Pro'),
              ),
            ],
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => const _CreateRuleDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ruleRepo = ref.watch(ruleRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Rules'),
        actions: [
          IconButton(
            tooltip: 'Add new rule',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddRuleDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<TransactionRule>>(
        stream: ruleRepo.watchRules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rules = snapshot.data ?? [];

          if (rules.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rule_rounded,
                      size: 64,
                      color: theme.hintColor.withOpacity(0.5),
                    ),
                    AppSpacing.h16,
                    Text(
                      'No rules created yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.h8,
                    Text(
                      'Create automated rules to rename merchants, override categories, or split transactions automatically upon SMS sync.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.hintColor),
                    ),
                    AppSpacing.h16,
                    FilledButton.icon(
                      onPressed: () => _showAddRuleDialog(context),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create First Rule'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: rules.length,
            separatorBuilder: (context, index) => AppSpacing.h12,
            itemBuilder: (context, index) {
              final rule = rules[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.borderMd,
                  side: BorderSide(color: theme.dividerColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Icon(
                              Icons.bolt_rounded,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          AppSpacing.w12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rule.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                if (rule.description != null && rule.description!.isNotEmpty) ...[
                                  AppSpacing.h4,
                                  Text(
                                    rule.description!,
                                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Switch(
                            value: rule.isActive,
                            onChanged: (active) async {
                              await ruleRepo.insertRule(
                                rule.copyWith(
                                  isActive: active,
                                  updatedAt: DateTime.now(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            onPressed: () async {
                              await ruleRepo.deleteRule(rule.id);
                            },
                          ),
                        ],
                      ),
                      AppSpacing.h8,
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final cond in rule.conditions)
                            Chip(
                              label: Text(
                                'IF ${cond.field.name} ${cond.operator.name} "${cond.value}"',
                                style: const TextStyle(fontSize: 11),
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          for (final act in rule.actions)
                            Chip(
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                              label: Text(
                                'SET ${act.field.name} → ${act.value}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CreateRuleDialog extends ConsumerStatefulWidget {
  const _CreateRuleDialog();

  @override
  ConsumerState<_CreateRuleDialog> createState() => _CreateRuleDialogState();
}

class _CreateRuleDialogState extends ConsumerState<_CreateRuleDialog> {
  final _nameController = TextEditingController();
  final _keywordController = TextEditingController();
  final _targetCategoryController = TextEditingController();
  TransactionField _matchField = TransactionField.merchant;
  ConditionOperator _conditionOp = ConditionOperator.contains;

  @override
  void dispose() {
    _nameController.dispose();
    _keywordController.dispose();
    _targetCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Transaction Rule'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Rule Name',
                hintText: 'e.g., Starbucks → Food',
              ),
            ),
            AppSpacing.h16,
            Text(
              'WHEN TRANSACTION MATCHES:',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.h8,
            DropdownButtonFormField<TransactionField>(
              value: _matchField,
              decoration: const InputDecoration(labelText: 'Field'),
              items: const [
                DropdownMenuItem(
                  value: TransactionField.merchant,
                  child: Text('Merchant Name'),
                ),
                DropdownMenuItem(
                  value: TransactionField.category,
                  child: Text('Category'),
                ),
                DropdownMenuItem(
                  value: TransactionField.narration,
                  child: Text('Narration / Description'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _matchField = val);
              },
            ),
            AppSpacing.h8,
            DropdownButtonFormField<ConditionOperator>(
              value: _conditionOp,
              decoration: const InputDecoration(labelText: 'Condition'),
              items: const [
                DropdownMenuItem(
                  value: ConditionOperator.contains,
                  child: Text('Contains'),
                ),
                DropdownMenuItem(
                  value: ConditionOperator.equals,
                  child: Text('Equals Exactly'),
                ),
                DropdownMenuItem(
                  value: ConditionOperator.startsWith,
                  child: Text('Starts With'),
                ),
                DropdownMenuItem(
                  value: ConditionOperator.endsWith,
                  child: Text('Ends With'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _conditionOp = val);
              },
            ),
            AppSpacing.h8,
            TextField(
              controller: _keywordController,
              decoration: const InputDecoration(
                labelText: 'Keyword / Value',
                hintText: 'e.g., starbucks',
              ),
            ),
            AppSpacing.h16,
            Text(
              'THEN APPLY ACTION:',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.h8,
            TextField(
              controller: _targetCategoryController,
              decoration: const InputDecoration(
                labelText: 'Set Category To',
                hintText: 'e.g., Food & Dining',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            final name = _nameController.text.trim();
            final keyword = _keywordController.text.trim();
            final targetCategory = _targetCategoryController.text.trim();

            if (name.isEmpty || keyword.isEmpty || targetCategory.isEmpty) return;

            final ruleRepo = ref.read(ruleRepositoryProvider);
            final rule = TransactionRule(
              id: 'rule_${DateTime.now().millisecondsSinceEpoch}',
              name: name,
              description:
                  'Auto-categorize "${_matchField.name}" ${_conditionOp.name} "$keyword" → $targetCategory',
              priority: 100,
              conditions: [
                RuleCondition(
                  field: _matchField,
                  operator: _conditionOp,
                  value: keyword,
                ),
              ],
              actions: [
                RuleAction(
                  field: TransactionField.category,
                  actionType: ActionType.set,
                  value: targetCategory,
                ),
              ],
              isActive: true,
              isSystemTemplate: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            await ruleRepo.insertRule(rule);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save Rule'),
        ),
      ],
    );
  }
}

