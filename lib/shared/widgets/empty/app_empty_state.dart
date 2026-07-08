import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../buttons/app_button.dart';

/// A premium, responsive empty state view to display across core features.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const AppEmptyState({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel = null,
    this.onActionPressed = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: theme.colorScheme.primary),
            ),
            AppSpacing.h24,
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.h8,
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              AppSpacing.h24,
              AppButton(
                text: actionLabel!,
                onPressed: onActionPressed,
                type: ButtonType.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
