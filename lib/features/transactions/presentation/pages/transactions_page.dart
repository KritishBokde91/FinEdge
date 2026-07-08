import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/inputs/app_search_field.dart';
import '../../../../shared/widgets/inputs/app_filter_chip.dart';
import '../../../../shared/widgets/transactions/transaction_tile.dart';
import '../../../../shared/widgets/dialogs/add_transaction_dialog.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Categories matching SmsParser._classifyCategory output exactly
  final List<String> _categories = [
    'All',
    'Food',
    'Shopping',
    'Transport',
    'Entertainment',
    'Bills',
    'Investment',
    'Salary',
    'Recharge',
    'Transfer',
    'Cash',
    'Other',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txRepository = ref.watch(transactionRepositoryProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddTransactionDialog.show(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
        tooltip: 'Add manual transaction',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- Header & Search Bar ---
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction History',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.h16,
                  AppSearchField(
                    controller: _searchController,
                    hintText: 'Search merchant or account source...',
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim().toLowerCase();
                      });
                    },
                    onClear: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                ],
              ),
            ),

            // --- Horizontal Category Filters ---
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: AppFilterChip(
                      label: cat,
                      isSelected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            AppSpacing.h16,

            // --- Transactions Dynamic Stream List ---
            Expanded(
              child: StreamBuilder<List<TransactionEntity>>(
                stream: txRepository.watchAllTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allTx = snapshot.data ?? [];

                  // Apply local query filter algorithms
                  final filteredTx = allTx.where((tx) {
                    final matchesQuery =
                        tx.merchant.toLowerCase().contains(_searchQuery) ||
                        tx.accountSource.toLowerCase().contains(_searchQuery);
                    final matchesCategory =
                        _selectedCategory == 'All' ||
                        tx.category == _selectedCategory;
                    return matchesQuery && matchesCategory;
                  }).toList();

                  if (filteredTx.isEmpty) {
                    return Center(
                      child: Text(
                        'No transactions found.',
                        style: TextStyle(color: theme.hintColor),
                      ),
                    );
                  }

                  // Group transactions by date
                  final Map<String, List<TransactionEntity>> groupedTx = {};
                  for (final tx in filteredTx) {
                    final dateKey = _formatDateKey(tx.timestamp);
                    if (groupedTx[dateKey] == null) {
                      groupedTx[dateKey] = [];
                    }
                    groupedTx[dateKey]!.add(tx);
                  }

                  final keysList = groupedTx.keys.toList();

                  return ListView.builder(
                    itemCount: keysList.length,
                    itemBuilder: (context, index) {
                      final groupDate = keysList[index];
                      final groupItems = groupedTx[groupDate]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Text(
                              groupDate,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariantDark,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupItems.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final tx = groupItems[index];
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateKey(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final txDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (txDate == today) {
      return 'TODAY';
    } else if (txDate == yesterday) {
      return 'YESTERDAY';
    } else {
      return DateFormat('EEEE, d MMMM yyyy').format(timestamp).toUpperCase();
    }
  }
}
