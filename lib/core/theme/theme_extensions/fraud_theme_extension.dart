import 'package:flutter/material.dart';

/// Custom theme properties for the Heuristic / AI Fraud Engine alerts.
class FraudThemeExtension extends ThemeExtension<FraudThemeExtension> {
  final Color riskHigh;
  final Color riskMedium;
  final Color riskLow;
  final Color alertBannerBackground;

  const FraudThemeExtension({
    required this.riskHigh,
    required this.riskMedium,
    required this.riskLow,
    required this.alertBannerBackground,
  });

  @override
  FraudThemeExtension copyWith({
    Color? riskHigh,
    Color? riskMedium,
    Color? riskLow,
    Color? alertBannerBackground,
  }) {
    return FraudThemeExtension(
      riskHigh: riskHigh ?? this.riskHigh,
      riskMedium: riskMedium ?? this.riskMedium,
      riskLow: riskLow ?? this.riskLow,
      alertBannerBackground:
          alertBannerBackground ?? this.alertBannerBackground,
    );
  }

  @override
  FraudThemeExtension lerp(
    ThemeExtension<FraudThemeExtension>? other,
    double t,
  ) {
    if (other is! FraudThemeExtension) return this;
    return FraudThemeExtension(
      riskHigh: Color.lerp(riskHigh, other.riskHigh, t) ?? riskHigh,
      riskMedium: Color.lerp(riskMedium, other.riskMedium, t) ?? riskMedium,
      riskLow: Color.lerp(riskLow, other.riskLow, t) ?? riskLow,
      alertBannerBackground:
          Color.lerp(alertBannerBackground, other.alertBannerBackground, t) ??
          alertBannerBackground,
    );
  }
}
