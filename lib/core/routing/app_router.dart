import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import 'shell/app_navigation_shell.dart';

// Import Feature Pages
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/permissions/presentation/pages/permissions_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/transactions/presentation/pages/transaction_details_page.dart';
import '../../features/sms_intelligence/presentation/pages/sms_intelligence_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/ai_assistant/presentation/pages/ai_assistant_page.dart';

// Sub-routes (pushed on top of tabs, not part of bottom-nav shell)
import '../../features/budget_planner/presentation/pages/budget_planner_page.dart';
import '../../features/financial_goals/presentation/pages/goals_page.dart';
import '../../features/billing/presentation/pages/upgrade_page.dart';

class _ErrorView extends StatelessWidget {
  final Exception? error;
  const _ErrorView({this.error});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text('Unknown Route Error: ${error.toString()}')),
  );
}

/// Central routing controller configurations for the FinSight application.
/// Maps paths to screens, supports index preservation tabs, and defines sub-routes.
abstract class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'homeBranch');
  static final GlobalKey<NavigatorState> _txNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'txBranch');
  static final GlobalKey<NavigatorState> _analyticsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'analyticsBranch');
  static final GlobalKey<NavigatorState> _aiNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'aiBranch');
  static final GlobalKey<NavigatorState> _profileNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'profileBranch');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splashPath,
    errorBuilder: (context, state) => _ErrorView(error: state.error),

    redirect: (context, state) {
      return null;
    },

    routes: [
      // --- Standalone Routes (outside shell) ---
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.onboardingPath,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.permissionsPath,
        name: RouteNames.permissions,
        builder: (context, state) => const PermissionsPage(),
      ),
      GoRoute(
        path: RouteNames.authPath,
        name: RouteNames.auth,
        builder: (context, state) => const AuthPage(),
      ),

      // --- Full-screen sub-routes (pushed over the bottom-nav shell) ---
      GoRoute(
        path: RouteNames.budgetPath,
        name: RouteNames.budget,
        builder: (context, state) => const BudgetPlannerPage(),
      ),
      GoRoute(
        path: RouteNames.goalsPath,
        name: RouteNames.goals,
        builder: (context, state) => const GoalsPage(),
      ),
      GoRoute(
        path: RouteNames.upgradePath,
        name: RouteNames.upgrade,
        builder: (context, state) => const UpgradePage(),
      ),

      // --- Stateful Bottom Navigation Tab Shell ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home / Dashboard
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.homePath,
                name: RouteNames.home,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          // Tab 1: Transactions & History
          StatefulShellBranch(
            navigatorKey: _txNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.transactionsPath,
                name: RouteNames.transactions,
                builder: (context, state) => const TransactionsPage(),
                routes: [
                  GoRoute(
                    path: RouteNames.transactionDetailsPath,
                    name: RouteNames.transactionDetails,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return TransactionDetailsPage(transactionId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Tab 2: Analytics Reports — now fully implemented
          StatefulShellBranch(
            navigatorKey: _analyticsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.analyticsPath,
                name: RouteNames.analytics,
                builder: (context, state) => const AnalyticsPage(),
              ),
            ],
          ),
          // Tab 3: AI Assistant / Coach
          StatefulShellBranch(
            navigatorKey: _aiNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.aiPath,
                name: RouteNames.ai,
                builder: (context, state) => const AiAssistantPage(),
                routes: [
                  GoRoute(
                    path: 'sms_logs',
                    name: 'sms_logs',
                    builder: (context, state) => const SmsIntelligencePage(),
                  ),
                ],
              ),
            ],
          ),
          // Tab 4: Profile & Configurations — now fully implemented
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.profilePath,
                name: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
