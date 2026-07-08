import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';

enum ButtonType { primary, secondary, outlined, ghost, danger, success }

/// A highly reusable, premium component button supporting loading states,
/// animations, and Material 3 design system definitions.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;

  const AppButton({
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon = null,
    this.isFullWidth = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine background and text colors based on button type
    Color? backgroundColor;
    Color? foregroundColor;
    BorderSide? borderSide;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = theme.colorScheme.primary;
        foregroundColor = theme.colorScheme.onPrimary;
        break;
      case ButtonType.secondary:
        backgroundColor = theme.colorScheme.secondaryContainer;
        foregroundColor = theme.colorScheme.onSecondaryContainer;
        break;
      case ButtonType.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        borderSide = BorderSide(color: theme.colorScheme.outline);
        break;
      case ButtonType.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        break;
      case ButtonType.danger:
        backgroundColor = theme.colorScheme.error;
        foregroundColor = theme.colorScheme.onError;
        break;
      case ButtonType.success:
        backgroundColor = AppColors.success;
        foregroundColor = Colors.white;
        break;
    }

    final isDisabled = onPressed == null || isLoading;

    final childWidget = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          AppSpacing.w12,
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: foregroundColor),
          AppSpacing.w8,
        ],
        Text(
          text,
          style: AppTypography.buttonTextStyle(
            color: isDisabled
                ? foregroundColor.withOpacity(0.5)
                : foregroundColor,
          ),
        ),
      ],
    );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: backgroundColor.withOpacity(0.12),
      disabledForegroundColor: foregroundColor.withOpacity(0.38),
      elevation: 0,
      side: borderSide,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.lg,
      ),
      shape: AppRadius.shapeMd,
    );

    Widget button = ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: buttonStyle,
      child: childWidget,
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return Semantics(button: true, enabled: !isDisabled, child: button);
  }
}
