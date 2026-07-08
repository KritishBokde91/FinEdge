import 'package:flutter/material.dart';

/// Reusable Search field with clean icon highlights and text change callbacks.
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmit;

  const AppSearchField({
    this.controller = null,
    this.hintText = 'Search transactions, SMS, categories...',
    this.onChanged = null,
    this.onClear = null,
    this.onSubmit = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SearchBar(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmit != null ? (_) => onSubmit!() : null,
      leading: Icon(
        Icons.search_rounded,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
      ),
      trailing: [
        if (controller != null && controller!.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              controller!.clear();
              if (onClear != null) onClear!();
              if (onChanged != null) onChanged!('');
            },
          ),
      ],
    );
  }
}
