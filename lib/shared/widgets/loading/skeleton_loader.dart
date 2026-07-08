import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import 'shimmer_container.dart';

/// Pre-assembled shimmer layout structures simulating loading components.
abstract class SkeletonLoader {
  /// Simulates a standard list tile row loader
  static Widget listTile({double height = 72.0}) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          ShimmerContainer(width: 40, height: 40, borderRadius: 20),
          AppSpacing.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerContainer(width: 120, height: 16),
                AppSpacing.h8,
                ShimmerContainer(width: 80, height: 12),
              ],
            ),
          ),
          AppSpacing.w16,
          ShimmerContainer(width: 60, height: 20),
        ],
      ),
    );
  }

  /// Simulates a transaction details card loader
  static Widget card({double height = 150.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ShimmerContainer(width: 140, height: 20),
          AppSpacing.h16,
          ShimmerContainer(width: double.infinity, height: height - 56),
        ],
      ),
    );
  }
}
