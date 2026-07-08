import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography configuration for FinSight.
/// Uses Plus Jakarta Sans for displays/headings (modern, curved, premium)
/// and Inter for body text and labels (high readability, optimized for data and values).
abstract class AppTypography {
  // --- Core Font Families ---
  static final String displayFont =
      GoogleFonts.plusJakartaSans().fontFamily ?? 'Plus Jakarta Sans';
  static final String bodyFont = GoogleFonts.inter().fontFamily ?? 'Inter';

  /// Generates the base TextTheme for the application.
  static TextTheme getTextTheme(Color textColor) {
    return TextTheme(
      // --- Display Styles (Large, expressive headers) ---
      displayLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 57,
        fontWeight: FontWeight.w700,
        height: 1.12,
        letterSpacing: -0.25,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 1.16,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.22,
        color: textColor,
      ),

      // --- Headline Styles (Section headers, onboarding highlights) ---
      headlineLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: textColor,
      ),

      // --- Title Styles (Cards, navigation bars, sub-headers) ---
      titleLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.15,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
        color: textColor,
      ),

      // --- Body Styles (Standard descriptive text, transaction details) ---
      bodyLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: textColor,
      ),

      // --- Label & Caption Styles (Tags, transaction timestamps, table headers, metadata) ---
      labelLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
        color: textColor,
      ),
    );
  }

  // --- Specific Reusable Helpers for Fintech Data ---
  static TextStyle transactionAmountStyle({
    required double fontSize,
    required Color color,
    bool isBold = true,
  }) {
    return TextStyle(
      fontFamily: bodyFont,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
      color: color,
      letterSpacing: -0.5,
    );
  }

  static TextStyle buttonTextStyle({required Color color}) {
    return TextStyle(
      fontFamily: displayFont,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: color,
    );
  }
}
