import 'package:flutter/material.dart';

/// Centralized animation durations and curves configuration for FinSight.
/// Follows Material 3 motion specifications for fluid micro-interactions.
abstract class AppAnimations {
  // --- Animation Durations ---
  /// Very fast micro-interaction feedback (e.g., button press hover, checkmarks, state changes)
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Standard widget animations (e.g., list transitions, card expands, FAB status)
  static const Duration durationNormal = Duration(milliseconds: 250);

  /// Major screen transitions (e.g., bottom sheet slide-ins, page swaps, modal overlays)
  static const Duration durationSlow = Duration(milliseconds: 380);

  /// Slow details revealing (e.g., full reports loading, chart drawing transitions)
  static const Duration durationVerySlow = Duration(milliseconds: 600);

  // --- Animation Curves ---
  /// standard easing (fast acceleration, slow deceleration)
  static const Curve curveNormal = Curves.easeInOutCubic;

  /// Accelerate fast, settle slowly (excellent for enter transitions e.g. modal sliding up)
  static const Curve curveDecelerate = Curves.easeOutCubic;

  /// Accelerate slowly, settle fast (excellent for exit transitions)
  static const Curve curveAccelerate = Curves.easeInCubic;

  /// Bouncy transition for playful, modern micro-interactions (e.g., checkmark popping, FAB scale)
  static const Curve curveBouncy = Curves.elasticOut;

  /// Fluid physics curve for premium card slide transitions
  static const Curve curveFluid = Curves.fastOutSlowIn;
}
