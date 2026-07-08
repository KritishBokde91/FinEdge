import 'package:flutter/material.dart';

/// Reusable filter chip container with clean selection states.
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final Widget? avatar;

  const AppFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.avatar = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      avatar: avatar,
    );
  }
}
