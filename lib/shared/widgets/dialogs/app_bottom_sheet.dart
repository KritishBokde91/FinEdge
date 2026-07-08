import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

/// Reusable helper to show modern bottom sheets.
abstract class AppBottomSheet {
  /// Displays a customized modal bottom sheet wrapping a child widget.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [AppSpacing.h12, child, AppSpacing.h24],
          ),
        );
      },
    );
  }
}
