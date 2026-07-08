import 'package:flutter/material.dart';

/// Custom theme properties for secure local operations, biometrics, PIN guards, and key-management alerts.
class SecurityThemeExtension extends ThemeExtension<SecurityThemeExtension> {
  final Color biometricRingColor;
  final Color secureShieldColor;
  final Color keyboardNumberColor;
  final Color pinDotActiveColor;

  const SecurityThemeExtension({
    required this.biometricRingColor,
    required this.secureShieldColor,
    required this.keyboardNumberColor,
    required this.pinDotActiveColor,
  });

  @override
  SecurityThemeExtension copyWith({
    Color? biometricRingColor,
    Color? secureShieldColor,
    Color? keyboardNumberColor,
    Color? pinDotActiveColor,
  }) {
    return SecurityThemeExtension(
      biometricRingColor: biometricRingColor ?? this.biometricRingColor,
      secureShieldColor: secureShieldColor ?? this.secureShieldColor,
      keyboardNumberColor: keyboardNumberColor ?? this.keyboardNumberColor,
      pinDotActiveColor: pinDotActiveColor ?? this.pinDotActiveColor,
    );
  }

  @override
  SecurityThemeExtension lerp(
    ThemeExtension<SecurityThemeExtension>? other,
    double t,
  ) {
    if (other is! SecurityThemeExtension) return this;
    return SecurityThemeExtension(
      biometricRingColor:
          Color.lerp(biometricRingColor, other.biometricRingColor, t) ??
          biometricRingColor,
      secureShieldColor:
          Color.lerp(secureShieldColor, other.secureShieldColor, t) ??
          secureShieldColor,
      keyboardNumberColor:
          Color.lerp(keyboardNumberColor, other.keyboardNumberColor, t) ??
          keyboardNumberColor,
      pinDotActiveColor:
          Color.lerp(pinDotActiveColor, other.pinDotActiveColor, t) ??
          pinDotActiveColor,
    );
  }
}
