import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions/finance_theme_extension.dart';

/// Reusable circular gauge displaying spending progress relative to budget limits.
class BudgetProgressIndicator extends StatelessWidget {
  final double limit;
  final double spent;
  final double size;

  const BudgetProgressIndicator({
    required this.limit,
    required this.spent,
    this.size = 120.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final financeTheme = theme.extension<FinanceThemeExtension>()!;

    final ratio = limit > 0 ? (spent / limit) : 0.0;
    final percentage = (ratio * 100).toStringAsFixed(0);

    // Choose progress color based on budget thresholds
    Color progressColor;
    if (ratio >= 1.0) {
      progressColor = financeTheme.budgetLimitExceededColor;
    } else if (ratio >= 0.8) {
      progressColor = theme.colorScheme.error; // warning close to limit
    } else {
      progressColor = financeTheme.budgetProgressColor;
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              strokeWidth: size * 0.08,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentage%',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.18,
                  color: progressColor,
                ),
              ),
              AppSpacing.h4,
              Text(
                'spent',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                  fontSize: size * 0.09,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
