import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Reusable merchant avatar displaying logo initials on a colored background circle,
/// or fallback symbol/icon graphic.
class MerchantAvatar extends StatelessWidget {
  final String merchantName;
  final IconData? fallbackIcon;
  final double size;

  const MerchantAvatar({
    required this.merchantName,
    this.fallbackIcon = null,
    this.size = 40.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cleanName = merchantName.trim();
    final initials = cleanName.isNotEmpty
        ? cleanName.substring(0, cleanName.length >= 2 ? 2 : 1).toUpperCase()
        : '?';

    // Hash name to get a consistent index in our chart/theme colors
    final colorIndex = cleanName.hashCode.abs() % AppColors.chartPalette.length;
    final avatarColor = AppColors.chartPalette[colorIndex];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatarColor.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: fallbackIcon != null
          ? Icon(fallbackIcon, size: size * 0.5, color: avatarColor)
          : Text(
              initials,
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.bold,
                color: avatarColor,
              ),
            ),
    );
  }
}
