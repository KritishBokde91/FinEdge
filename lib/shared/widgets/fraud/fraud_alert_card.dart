import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions/fraud_theme_extension.dart';
import '../cards/app_card.dart';

/// A card alert warning users of suspicious financial SMS activities.
class FraudAlertCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onVerify;
  final VoidCallback? onDismiss;

  const FraudAlertCard({
    required this.title,
    required this.description,
    required this.onVerify,
    this.onDismiss = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fraudTheme = theme.extension<FraudThemeExtension>()!;

    return AppCard(
      color: fraudTheme.alertBannerBackground,
      borderSide: BorderSide(color: fraudTheme.riskHigh.withOpacity(0.5)),
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: fraudTheme.riskHigh,
                size: 24,
              ),
              AppSpacing.w8,
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: fraudTheme.riskHigh,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: fraudTheme.riskHigh,
                    size: 18,
                  ),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          AppSpacing.h8,
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.9)
                  : Colors.black87,
              height: 1.4,
            ),
          ),
          AppSpacing.h16,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onVerify,
                style: TextButton.styleFrom(
                  foregroundColor: fraudTheme.riskHigh,
                ),
                child: const Text('Verify Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
