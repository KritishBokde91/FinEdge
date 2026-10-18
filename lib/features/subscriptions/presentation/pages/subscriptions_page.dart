import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../core/di/use_case_providers.dart';
import '../../domain/entities/subscription_entity.dart';

class SubscriptionsPage extends ConsumerStatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  ConsumerState<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends ConsumerState<SubscriptionsPage> {
  bool _isDetecting = false;

  Future<void> _runSubscriptionDetection() async {
    setState(() => _isDetecting = true);
    try {
      final txRepo = ref.read(transactionRepositoryProvider);
      final detector = ref.read(detectSubscriptionsUseCaseProvider);
      final transactions = await txRepo.watchAllTransactions().first;
      final addedCount = await detector.detectAndSave(transactions);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              addedCount > 0
                  ? 'Detected and saved $addedCount recurring subscriptions!'
                  : 'Scan complete. No new subscriptions found.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to detect subscriptions: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDetecting = false);
      }
    }
  }

  void _showAddSubscriptionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => const _AddSubscriptionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subRepo = ref.watch(subscriptionRepositoryProvider);
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
        actions: [
          IconButton(
            tooltip: 'Auto-detect from history',
            icon: _isDetecting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome_rounded),
            onPressed: _isDetecting ? null : _runSubscriptionDetection,
          ),
          IconButton(
            tooltip: 'Add subscription',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddSubscriptionDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<SubscriptionEntity>>(
        stream: subRepo.watchAllSubscriptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final subscriptions = snapshot.data ?? [];
          final activeSubs = subscriptions.where((s) => s.isActive).toList();
          final totalMonthly = activeSubs.fold<double>(0.0, (sum, sub) {
            final multiplier = switch (sub.billingCycle.toLowerCase()) {
              'weekly' => 4.33,
              'quarterly' => 1 / 3,
              'yearly' => 1 / 12,
              _ => 1.0,
            };
            return sum + (sub.amount * multiplier);
          });

          return CustomScrollView(
            slivers: [
              // Summary card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      gradient: theme.brightness == Brightness.dark
                          ? LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.8),
                                theme.colorScheme.primary.withOpacity(0.4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.75),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Monthly Cost',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                        AppSpacing.h8,
                        Text(
                          currencyFormatter.format(totalMonthly),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AppSpacing.h12,
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: AppRadius.borderSm,
                              ),
                              child: Text(
                                '${activeSubs.length} Active',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: _isDetecting ? null : _runSubscriptionDetection,
                              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                              label: const Text(
                                'Scan SMS',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Subscriptions list
              if (subscriptions.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 64,
                            color: theme.hintColor.withOpacity(0.5),
                          ),
                          AppSpacing.h16,
                          Text(
                            'No subscriptions found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSpacing.h8,
                          Text(
                            'Tap "Auto-detect" to scan recurring transactions or add one manually.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.hintColor),
                          ),
                          AppSpacing.h16,
                          FilledButton.icon(
                            onPressed: _runSubscriptionDetection,
                            icon: const Icon(Icons.auto_awesome_rounded),
                            label: const Text('Auto-detect Recurring'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final sub = subscriptions[index];
                        final nextDateStr = DateFormat('MMM dd, yyyy').format(sub.nextBillingDate);
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.borderMd,
                            side: BorderSide(color: theme.dividerColor),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Icon(
                                Icons.subscriptions_rounded,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              sub.merchant,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${sub.billingCycle.toUpperCase()} • Next: $nextDateStr',
                              style: TextStyle(color: theme.hintColor, fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currencyFormatter.format(sub.amount),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: sub.isActive ? theme.colorScheme.onSurface : theme.hintColor,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (action) async {
                                    if (action == 'toggle') {
                                      await subRepo.updateSubscription(
                                        sub.copyWith(isActive: !sub.isActive),
                                      );
                                    } else if (action == 'delete') {
                                      await subRepo.deleteSubscription(sub.id);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'toggle',
                                      child: Text(sub.isActive ? 'Pause' : 'Resume'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: subscriptions.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AddSubscriptionDialog extends ConsumerStatefulWidget {
  const _AddSubscriptionDialog();

  @override
  ConsumerState<_AddSubscriptionDialog> createState() =>
      _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState
    extends ConsumerState<_AddSubscriptionDialog> {
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  String _billingCycle = 'monthly';
  final DateTime _nextBillingDate =
      DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Subscription'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _merchantController,
              decoration: const InputDecoration(
                labelText: 'Service / Merchant',
                hintText: 'e.g., Netflix, Spotify',
              ),
            ),
            AppSpacing.h16,
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                hintText: 'e.g., 499.00',
              ),
            ),
            AppSpacing.h16,
            DropdownButtonFormField<String>(
              value: _billingCycle,
              decoration: const InputDecoration(labelText: 'Billing Cycle'),
              items: const [
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')),
                DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _billingCycle = val);
                }
              },
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
            final merchant = _merchantController.text.trim();
            final amount =
                double.tryParse(_amountController.text.trim()) ?? 0.0;
            if (merchant.isEmpty || amount <= 0) return;

            final repo = ref.read(subscriptionRepositoryProvider);
            final newSub = SubscriptionEntity(
              id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
              merchant: merchant,
              amount: amount,
              billingCycle: _billingCycle,
              nextBillingDate: _nextBillingDate,
              isActive: true,
            );
            await repo.insertSubscription(newSub);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

