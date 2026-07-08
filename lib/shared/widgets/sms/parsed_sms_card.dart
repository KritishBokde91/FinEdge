import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions/finance_theme_extension.dart';
import '../cards/app_card.dart';
import 'confidence_badge.dart';

/// Shows parsed structured entities extracted from a raw financial SMS.
class ParsedSmsCard extends StatelessWidget {
  final String rawText;
  final String extractedMerchant;
  final double extractedAmount;
  final String category;
  final bool isIncome;
  final double extractionConfidence;

  const ParsedSmsCard({
    required this.rawText,
    required this.extractedMerchant,
    required this.extractedAmount,
    required this.category,
    required this.isIncome,
    required this.extractionConfidence,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final financeTheme = theme.extension<FinanceThemeExtension>()!;

    final currencyFormat = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 2);
    final amountColor = isIncome
        ? financeTheme.incomeColor
        : financeTheme.expenseColor;

    return AppCard(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConfidenceBadge(confidence: extractionConfidence),
              Text(
                category,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          AppSpacing.h16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Extracted Merchant',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                    AppSpacing.h4,
                    Text(
                      extractedMerchant,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Extracted Amount',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.6,
                      ),
                    ),
                  ),
                  AppSpacing.h4,
                  Text(
                    '${isIncome ? "+" : "-"}${currencyFormat.format(extractedAmount)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: amountColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.h16,
          Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Raw SMS Message Text',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
                AppSpacing.h8,
                Text(
                  rawText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
