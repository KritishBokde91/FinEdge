import 'package:flutter/material.dart';

/// Reusable App Bar for standard screen layouts.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const AppHeader({
    required this.title,
    this.actions = null,
    this.showLeading = true,
    this.leading = null,
    this.bottom = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: showLeading ? (leading ?? const BackButton()) : null,
      actions: actions,
      bottom: bottom,
      centerTitle: true,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
