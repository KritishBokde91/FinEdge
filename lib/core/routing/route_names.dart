/// Static route names and paths mapping for FinSight.
abstract class RouteNames {
  static const String splash = 'splash';
  static const String splashPath = '/splash';

  static const String onboarding = 'onboarding';
  static const String onboardingPath = '/onboarding';

  static const String permissions = 'permissions';
  static const String permissionsPath = '/permissions';

  static const String auth = 'auth';
  static const String authPath = '/auth';

  // --- Shell Tabs ---
  static const String home = 'home';
  static const String homePath = '/home';

  static const String transactions = 'transactions';
  static const String transactionsPath = '/transactions';

  static const String transactionDetails = 'transactionDetails';
  static const String transactionDetailsPath =
      'details/:id'; // nested under transactions

  static const String analytics = 'analytics';
  static const String analyticsPath = '/analytics';

  static const String ai = 'ai';
  static const String aiPath = '/ai';

  static const String profile = 'profile';
  static const String profilePath = '/profile';

  // --- Full-screen sub-routes ---
  static const String budget = 'budget';
  static const String budgetPath = '/budget';

  static const String goals = 'goals';
  static const String goalsPath = '/goals';
}
