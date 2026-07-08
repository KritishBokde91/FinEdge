import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// A premium glassmorphic card container with backdrop blur,
/// translucent borders, and custom background tinting.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final Color? tintColor;
  final VoidCallback? onTap;

  const GlassCard({
    required this.child,
    this.blur = 12.0,
    this.opacity = 0.08,
    this.padding = AppSpacing.paddingLg,
    this.tintColor = null,
    this.onTap = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = tintColor ?? theme.colorScheme.surface;

    Widget cardBody = ClipRRect(
      borderRadius: AppRadius.borderLg,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: baseColor.withOpacity(opacity),
            borderRadius: AppRadius.borderLg,
            border: Border.all(
              color:
                  (theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(0.08),
              width: 1.0,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      cardBody = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: cardBody,
      );
    }

    return cardBody;
  }
}
