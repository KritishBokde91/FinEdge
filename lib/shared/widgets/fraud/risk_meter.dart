import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions/fraud_theme_extension.dart';

/// Renders a horizontal bar displaying safety risk categories (Low, Medium, High).
class RiskMeter extends StatelessWidget {
  final double score; // Range from 0.0 (safe) to 1.0 (highly risky)

  const RiskMeter({required this.score, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fraudTheme = theme.extension<FraudThemeExtension>()!;

    Color activeColor;
    String ratingText;

    if (score < 0.3) {
      activeColor = fraudTheme.riskLow;
      ratingText = 'Safe';
    } else if (score < 0.7) {
      activeColor = fraudTheme.riskMedium;
      ratingText = 'Suspicious';
    } else {
      activeColor = fraudTheme.riskHigh;
      ratingText = 'High Risk';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Security Status',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
            Text(
              ratingText,
              style: theme.textTheme.labelMedium?.copyWith(
                color: activeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        AppSpacing.h8,
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final activeWidth = constraints.maxWidth * score;
                return Container(
                  width: activeWidth,
                  height: 8,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
