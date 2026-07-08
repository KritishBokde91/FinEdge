import 'package:flutter/material.dart';

/// Centralized color system for FinSight.
/// Defines color tokens for both light and dark themes using a premium, minimal,
/// and AI-first fintech aesthetic.
abstract class AppColors {
  // --- Core Colors (Light) ---
  static const Color primaryLight = Color(0xFF2E3192); // Deep Indigo
  static const Color primaryContainerLight = Color(0xFFE8E9FF);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);

  static const Color secondaryLight = Color(0xFF0D0E12); // Near Black
  static const Color secondaryContainerLight = Color(0xFFF1F2F6);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);

  static const Color tertiaryLight = Color(0xFF00A86B); // Emerald Green
  static const Color tertiaryContainerLight = Color(0xFFD1FAE5);

  static const Color backgroundLight = Color(0xFFF8F9FA); // Soft White
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F3F5);

  static const Color onBackgroundLight = Color(0xFF1F2937); // Dark Slate Grey
  static const Color onSurfaceLight = Color(0xFF1F2937);
  static const Color onSurfaceVariantLight = Color(0xFF4B5563);

  // --- Core Colors (Dark) ---
  static const Color primaryDark = Color(0xFF7C7FFF); // Vibrant Light Indigo
  static const Color primaryContainerDark = Color(0xFF1A1B4B);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);

  static const Color secondaryDark = Color(0xFFE5E7EB); // Soft Grey
  static const Color secondaryContainerDark = Color(0xFF1F2937);
  static const Color onSecondaryDark = Color(0xFF111827);

  static const Color tertiaryDark = Color(0xFF34D399); // Emerald Green Light
  static const Color tertiaryContainerDark = Color(0xFF064E3B);

  static const Color backgroundDark = Color(0xFF0A0A0C); // Near Black
  static const Color surfaceDark = Color(0xFF121214); // Deep Grey Surface
  static const Color surfaceVariantDark = Color(0xFF1F1F23);

  static const Color onBackgroundDark = Color(0xFFF3F4F6); // Soft Grey White
  static const Color onSurfaceDark = Color(0xFFF3F4F6);
  static const Color onSurfaceVariantDark = Color(0xFF9CA3AF);

  // --- Common Outline/Divider Colors ---
  static const Color outlineLight = Color(0xFFE5E7EB);
  static const Color outlineDark = Color(0xFF2D2E33);

  // --- Status & Semantic Colors (Light) ---
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Coral Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // --- FinTech Domain Specific Colors ---
  static const Color income = Color(0xFF10B981); // Green for income
  static const Color expense = Color(0xFFEF4444); // Red for expenses
  static const Color budget = Color(0xFF8B5CF6); // Purple for budgets
  static const Color analytics = Color(0xFF3B82F6); // Indigo-Blue for graphs
  static const Color ai = Color(
    0xFFEC4899,
  ); // Deep Pink / Glowing Magenta for AI
  static const Color security = Color(
    0xFFF59E0B,
  ); // Orange-Gold for biometrics/fraud warnings
  static const Color fraud = Color(
    0xFFDC2626,
  ); // Crimson Red for direct fraud alerts

  // --- Premium Charts Color Palette ---
  static const List<Color> chartPalette = [
    Color(0xFF2E3192), // Deep Indigo
    Color(0xFF00A86B), // Emerald
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF59E0B), // Amber
    Color(0xFF06B6D4), // Cyan
    Color(0xFFF43F5E), // Rose
  ];

  // --- Financial Heatmap Palette ---
  static const List<Color> heatmapColors = [
    Color(0xFFFEF2F2), // Lightest Red (no activity)
    Color(0xFFFEE2E2),
    Color(0xFFFCA5A5),
    Color(0xFFF87171),
    Color(0xFFEF4444),
    Color(0xFFDC2626),
    Color(0xFFB91C1C), // Darkest Red (high spending density)
  ];
}
