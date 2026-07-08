import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_extensions/finance_theme_extension.dart';
import 'merchant_avatar.dart';

/// Reusable tile listing a transaction showing description, category,
/// date, dynamic payment status color, and amount value.
class TransactionTile extends StatelessWidget {
  final String title;
  final String category;
  final DateTime date;
  final double amount;
  final bool isIncome;
  final String? accountSource;
  final VoidCallback? onTap;

  const TransactionTile({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.accountSource = null,
    this.onTap = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final financeTheme = theme.extension<FinanceThemeExtension>()!;

    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    final currencyFormat = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 2);
    final amountText =
        '${isIncome ? "+" : "-"}${currencyFormat.format(amount)}';
    final amountColor = isIncome
        ? financeTheme.incomeColor
        : financeTheme.expenseColor;

    return ListTile(
      onTap: onTap,
      leading: MerchantAvatar(merchantName: title),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AppSpacing.w8,
          Text(
            amountText,
            style: AppTypography.transactionAmountStyle(
              fontSize: 16,
              color: amountColor,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$category${accountSource != null ? " • $accountSource" : ""}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                ),
              ),
            ),
            Text(
              formattedDate,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
