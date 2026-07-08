import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/navigation/app_bottom_bar.dart';

/// AppNavigationShell coordinates the stateful tab layouts using GoRouter's
/// StatefulNavigationShell, preserving the page state of Home, Transactions,
/// Analytics, AI Assistant, and Profile screens.
class AppNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigationShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    final bottomBarItems = [
      const AppBottomBarItem(
        icon: Icons.space_dashboard_outlined,
        selectedIcon: Icons.space_dashboard_rounded,
        label: 'Home',
      ),
      const AppBottomBarItem(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
        label: 'Transactions',
      ),
      const AppBottomBarItem(
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics_rounded,
        label: 'Analytics',
      ),
      const AppBottomBarItem(
        icon: Icons.assistant_outlined,
        selectedIcon: Icons.assistant_rounded,
        label: 'AI Coach',
      ),
      const AppBottomBarItem(
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomBar(
        currentIndex: navigationShell.currentIndex,
        items: bottomBarItems,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
