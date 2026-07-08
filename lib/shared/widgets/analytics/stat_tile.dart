import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions/finance_theme_extension.dart';
import '../cards/app_card.dart';

/// Reusable stat tile displaying key financial metric numbers and growth indicators.
class StatTile extends StatelessWidget {
  final String title;
  final String value;
  final double? percentageChange; // e.g. 12.5 (positive) or -4.2 (negative)
  final String? subtitle;

  const StatTile({
    required this.title,
    required this.value,
    this.percentageChange = null,
    this.subtitle = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final financeTheme = theme.extension<FinanceThemeExtension>()!;

    Widget? percentageWidget;
    if (percentageChange != null) {
      final isPositive = percentageChange! >= 0;
      final color = isPositive
          ? financeTheme.incomeColor
          : financeTheme.expenseColor;
      final icon = isPositive
          ? Icons.trending_up_rounded
          : Icons.trending_down_rounded;
      final prefix = isPositive ? '+' : '';

      percentageWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            AppSpacing.w4,
            Text(
              '$prefix${percentageChange!.toStringAsFixed(1)}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
              ?percentageWidget,
            ],
          ),
          AppSpacing.h8,
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            AppSpacing.h4,
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
