import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/preferences_service.dart';
import 'core/widgets/app_lifecycle_wrapper.dart';

// Providers for global infrastructure services (injected in Riverpod)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main first');
});

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService(ref.watch(sharedPreferencesProvider));
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system navigation overlay styles
  AppTheme.setSystemOverlay(false);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsService = ref.watch(preferencesServiceProvider);
    final themeMode = prefsService.getThemeMode();

    ThemeMode currentThemeMode;
    switch (themeMode) {
      case 'light':
        currentThemeMode = ThemeMode.light;
        break;
      case 'dark':
        currentThemeMode = ThemeMode.dark;
        break;
      default:
        currentThemeMode = ThemeMode.system;
    }

    return MaterialApp.router(
      title: 'FinSight',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return AppLifecycleWrapper(child: child!);
      },
    );
  }
}
