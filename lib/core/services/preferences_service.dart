import 'package:shared_preferences/shared_preferences.dart';

/// Service managing lightweight on-device persistent user configurations.
class PreferencesService {
  final SharedPreferences _prefs;

  const PreferencesService(this._prefs);

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyInitialSetupCompleted = 'initial_setup_completed';

  // --- Theme Mode ---
  String getThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'system';
  }

  Future<bool> setThemeMode(String value) {
    return _prefs.setString(_keyThemeMode, value);
  }

  // --- Biometric Lock Screen Toggle ---
  bool isBiometricEnabled() {
    return _prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  Future<bool> setBiometricEnabled(bool enabled) {
    return _prefs.setBool(_keyBiometricEnabled, enabled);
  }

  // --- Onboarding Progress ---
  bool isOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<bool> setOnboardingCompleted(bool completed) {
    return _prefs.setBool(_keyOnboardingCompleted, completed);
  }

  // --- Initial Database/Setup Run ---
  bool isInitialSetupCompleted() {
    return _prefs.getBool(_keyInitialSetupCompleted) ?? false;
  }

  Future<bool> setInitialSetupCompleted(bool completed) {
    return _prefs.setBool(_keyInitialSetupCompleted, completed);
  }

  // --- Last SMS Sync Timestamp ---
  static const String _keyLastSmsSync = 'last_sms_sync_timestamp';

  int getLastSmsSyncTimestamp() {
    return _prefs.getInt(_keyLastSmsSync) ?? 0;
  }

  Future<bool> setLastSmsSyncTimestamp(int timestamp) {
    return _prefs.setInt(_keyLastSmsSync, timestamp);
  }
}
