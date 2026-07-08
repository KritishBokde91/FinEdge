import 'package:flutter/material.dart';

/// Custom theme properties for the Analytics, charts, and reporting engines.
class AnalyticsThemeExtension extends ThemeExtension<AnalyticsThemeExtension> {
  final Color gridLineColor;
  final Color chartLabelColor;
  final List<Color> chartColors;
  final List<Color> heatmapScale;

  const AnalyticsThemeExtension({
    required this.gridLineColor,
    required this.chartLabelColor,
    required this.chartColors,
    required this.heatmapScale,
  });

  @override
  AnalyticsThemeExtension copyWith({
    Color? gridLineColor,
    Color? chartLabelColor,
    List<Color>? chartColors,
    List<Color>? heatmapScale,
  }) {
    return AnalyticsThemeExtension(
      gridLineColor: gridLineColor ?? this.gridLineColor,
      chartLabelColor: chartLabelColor ?? this.chartLabelColor,
      chartColors: chartColors ?? this.chartColors,
      heatmapScale: heatmapScale ?? this.heatmapScale,
    );
  }

  @override
  AnalyticsThemeExtension lerp(
    ThemeExtension<AnalyticsThemeExtension>? other,
    double t,
  ) {
    if (other is! AnalyticsThemeExtension) return this;
    return AnalyticsThemeExtension(
      gridLineColor:
          Color.lerp(gridLineColor, other.gridLineColor, t) ?? gridLineColor,
      chartLabelColor:
          Color.lerp(chartLabelColor, other.chartLabelColor, t) ??
          chartLabelColor,
      chartColors: List.generate(
        chartColors.length,
        (i) =>
            Color.lerp(chartColors[i], other.chartColors[i], t) ??
            chartColors[i],
      ),
      heatmapScale: List.generate(
        heatmapScale.length,
        (i) =>
            Color.lerp(heatmapScale[i], other.heatmapScale[i], t) ??
            heatmapScale[i],
      ),
    );
  }
}
