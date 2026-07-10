import '../services/preferences_service.dart';

/// Repository managing biometric locks and session timeout periods.
///
/// Ported from AppLockRepository.kt.
class AppLockRepository {
  final PreferencesService _prefs;

  const AppLockRepository(this._prefs);

  /// Checks if local biometric locking is active.
  bool isAppLockEnabled() => _prefs.isBiometricEnabled();

  /// Toggles biometric lock screen option.
  Future<bool> setAppLockEnabled(bool enabled) => _prefs.setBiometricEnabled(enabled);
}
