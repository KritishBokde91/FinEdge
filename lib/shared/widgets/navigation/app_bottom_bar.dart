import 'package:flutter/material.dart';

/// Reusable navigation bottom bar item configuration representation.
class AppBottomBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const AppBottomBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Reusable bottom bar layout widget.
class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final List<AppBottomBarItem> items;
  final ValueChanged<int> onTap;

  const AppBottomBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: items.map((item) {
        return NavigationDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.selectedIcon),
          label: item.label,
        );
      }).toList(),
    );
  }
}
