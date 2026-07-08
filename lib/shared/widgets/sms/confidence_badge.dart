import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// Reusable status badge mapping confidence rates to color alerts.
class ConfidenceBadge extends StatelessWidget {
  final double confidence; // Range from 0.0 to 1.0

  const ConfidenceBadge({required this.confidence, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color color;
    String statusText;

    if (confidence >= 0.85) {
      color = AppColors.success;
      statusText = 'High Match';
    } else if (confidence >= 0.60) {
      color = AppColors.warning;
      statusText = 'Medium Match';
    } else {
      color = AppColors.error;
      statusText = 'Low Match';
    }

    final percentageText = '${(confidence * 100).toStringAsFixed(0)}%';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: AppRadius.borderCircular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          AppSpacing.w8,
          Text(
            '$statusText ($percentageText)',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
