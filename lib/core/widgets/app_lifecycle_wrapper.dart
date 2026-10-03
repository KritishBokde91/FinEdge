import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routing/app_router.dart';
import '../routing/route_names.dart';
import '../../main.dart';

class AppLifecycleWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleWrapper({super.key, required this.child});

  @override
  ConsumerState<AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends ConsumerState<AppLifecycleWrapper>
    with WidgetsBindingObserver {
  DateTime? _backgroundTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_backgroundTime != null) {
        final elapsed = DateTime.now().difference(_backgroundTime!);
        _backgroundTime = null;

        // If backgrounded for more than 5 seconds, lock the app
        if (elapsed.inSeconds >= 5) {
          _lockApp();
        }
      }
    }
  }

  void _lockApp() {
    final rawPrefs = ref.read(sharedPreferencesProvider);
    final pin = rawPrefs.getString('user_pin');
    if (pin == null || pin.isEmpty) return;

    final router = AppRouter.router;
    final currentPath = router.routerDelegate.currentConfiguration.uri.path;

    // Do not lock if already on splash, onboarding, permissions or auth screen
    if (currentPath != RouteNames.authPath &&
        currentPath != RouteNames.splashPath &&
        currentPath != RouteNames.onboardingPath &&
        currentPath != RouteNames.permissionsPath) {
      router.goNamed(RouteNames.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
