import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../shared/widgets/navigation/app_header.dart';
import '../../../../shared/widgets/transactions/merchant_avatar.dart';
import '../../../../shared/widgets/transactions/transaction_badge.dart';
import '../../../../shared/widgets/cards/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';

class TransactionDetailsPage extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailsPage({required this.transactionId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final txRepository = ref.watch(transactionRepositoryProvider);

    return Scaffold(
      appBar: AppHeader(
        title: 'Transaction Details',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder(
        future: txRepository.getTransactionById(transactionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Failed to load transaction details.'),
            );
          }

          final result = snapshot.data!;
          return result.fold(
            (failure) => Center(child: Text('Error: ${failure.message}')),
            (tx) {
              final formattedTime = DateFormat(
                'MMMM dd, yyyy • hh:mm a',
              ).format(tx.timestamp);
              final formattedAmount =
                  '${tx.isIncome ? '+' : '-'} ${tx.currency} ${tx.amount.toStringAsFixed(2)}';
              final referenceCode = tx.reference?.trim().isNotEmpty == true
                  ? tx.reference!.trim()
                  : 'TX-${tx.id.substring(0, 8).toUpperCase()}';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    AppSpacing.h16,

                    // --- Merchant Header Card ---
                    Center(
                      child: Column(
                        children: [
                          MerchantAvatar(merchantName: tx.merchant, size: 72),
                          AppSpacing.h16,
                          Text(
                            tx.merchant,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSpacing.h8,
                          TransactionBadge(label: tx.category),
                          AppSpacing.h24,
                          Text(
                            formattedAmount,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: tx.isIncome
                                  ? AppColors.success
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          AppSpacing.h8,
                          Text(
                            formattedTime,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.h40,

                    // --- Info Fields Section ---
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: AppRadius.borderLg,
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            context: context,
                            label: 'Account Source',
                            value: tx.accountSource,
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context: context,
                            label: 'Reference Code',
                            value: referenceCode,
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context: context,
                            label: 'Status',
                            value: 'Completed',
                            valueColor: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.h24,

                    // --- AI Coaching Insight (Placeholder Mock Card) ---
                    GlassCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 20,
                              ),
                              AppSpacing.w8,
                              Text(
                                'AI Assistant Coaching Tip',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.h12,
                          const Text(
                            'FinSight AI is analyzing this transaction. Once NLP pre-processing is completed, matching recurring expenditure insights will appear here.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
