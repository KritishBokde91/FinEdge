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

  // --- Contacts VPA Mapping Toggle ---
  static const String _keyUseContactsForVpa = 'use_contacts_for_vpa';

  bool useContactsForVpa() {
    return _prefs.getBool(_keyUseContactsForVpa) ?? false;
  }

  Future<bool> setUseContactsForVpa(bool enabled) {
    return _prefs.setBool(_keyUseContactsForVpa, enabled);
  }

  // --- Theme Styles Preference Mappings ---
  static const String _keyAccentColor = 'accent_color';
  static const String _keyAppFont = 'app_font';
  static const String _keyCoverStyle = 'cover_style';
  static const String _keyNavBarStyle = 'navbar_style';
  static const String _keyNumberFormatStyle = 'number_format_style';
  static const String _keyThemeStyle = 'theme_style';
  static const String _keyUnifiedCurrencyMode = 'unified_currency_mode';
  static const String _keyDisplayCurrency = 'display_currency';

  String getAccentColor() => _prefs.getString(_keyAccentColor) ?? 'blue';
  Future<bool> setAccentColor(String color) => _prefs.setString(_keyAccentColor, color);

  String getAppFont() => _prefs.getString(_keyAppFont) ?? 'system';
  Future<bool> setAppFont(String font) => _prefs.setString(_keyAppFont, font);

  String getCoverStyle() => _prefs.getString(_keyCoverStyle) ?? 'default';
  Future<bool> setCoverStyle(String style) => _prefs.setString(_keyCoverStyle, style);

  String getNavBarStyle() => _prefs.getString(_keyNavBarStyle) ?? 'standard';
  Future<bool> setNavBarStyle(String style) => _prefs.setString(_keyNavBarStyle, style);

  String getNumberFormatStyle() => _prefs.getString(_keyNumberFormatStyle) ?? 'en_IN';
  Future<bool> setNumberFormatStyle(String style) => _prefs.setString(_keyNumberFormatStyle, style);

  String getThemeStyle() => _prefs.getString(_keyThemeStyle) ?? 'dynamic';
  Future<bool> setThemeStyle(String style) => _prefs.setString(_keyThemeStyle, style);

  bool isUnifiedCurrencyMode() => _prefs.getBool(_keyUnifiedCurrencyMode) ?? false;
  Future<bool> setUnifiedCurrencyMode(bool value) => _prefs.setBool(_keyUnifiedCurrencyMode, value);

  String getDisplayCurrency() => _prefs.getString(_keyDisplayCurrency) ?? 'INR';
  Future<bool> setDisplayCurrency(String currency) => _prefs.setString(_keyDisplayCurrency, currency);
}
