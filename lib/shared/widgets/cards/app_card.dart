import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// A reusable base card container conforming to Material 3 shapes,
/// padding tokens, and clean background shading.
class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BorderSide? borderSide;

  const AppCard({
    required this.child,
    this.color = null,
    this.padding = AppSpacing.paddingLg,
    this.onTap = null,
    this.borderSide = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget cardContent = Padding(padding: padding, child: child);

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: cardContent,
      );
    }

    return Card(
      color: color ?? theme.cardTheme.color ?? theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg,
        side:
            borderSide ??
            BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: cardContent,
    );
  }
}
