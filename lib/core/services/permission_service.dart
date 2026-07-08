import 'dart:io';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../logger/app_logger.dart';

/// Service coordinating biometric checks and system permissions prompts.
class PermissionService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if device is capable of local biometric validations.
  Future<bool> canCheckBiometrics() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return isSupported && canCheck;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to check biometric capability', e, stackTrace);
      return false;
    }
  }

  /// Triggers a local authentication prompt.
  Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to access your financial vaults',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed biometric authentication validation', e, stackTrace);
      return false;
    }
  }

  static const _channel = MethodChannel('com.genzloop.finsight_ai/sms');

  /// Stubbed check for SMS reads (Android specific; implemented natively in later phases)
  Future<bool> checkSmsPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool granted = await _channel.invokeMethod('checkSmsPermission') ?? false;
      return granted;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to check native SMS permission status', e, stackTrace);
      return false;
    }
  }

  /// Request SMS access prompts
  Future<bool> requestSmsPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool triggered = await _channel.invokeMethod('requestSmsPermission') ?? false;
      return triggered;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to request native SMS permissions', e, stackTrace);
      return false;
    }
  }

  /// Check notification permission status (Android 13+ requires POST_NOTIFICATIONS)
  Future<bool> checkNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool granted = await _channel.invokeMethod('checkNotificationPermission') ?? false;
      return granted;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to check notification permission status', e, stackTrace);
      return false;
    }
  }

  /// Request notification permission (Android 13+ POST_NOTIFICATIONS)
  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool triggered = await _channel.invokeMethod('requestNotificationPermission') ?? false;
      return triggered;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to request notification permissions', e, stackTrace);
      return false;
    }
  }
}
