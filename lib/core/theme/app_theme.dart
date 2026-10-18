// ignore_for_file: deprecated_member_use
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'theme_extensions/ai_theme_extension.dart';
import 'theme_extensions/analytics_theme_extension.dart';
import 'theme_extensions/finance_theme_extension.dart';
import 'theme_extensions/fraud_theme_extension.dart';
import 'theme_extensions/security_theme_extension.dart';

/// AppTheme manages the initialization and assembly of the light and dark
/// ThemeData structures, component styles, and custom theme extensions.
abstract class AppTheme {
  // --- Common Helper: System Overlay Style ---
  static void setSystemOverlay(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  // --- Light Theme Definition ---
  static ThemeData get lightTheme {
    final baseColorScheme = ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.onPrimaryLight,
      primaryContainer: AppColors.primaryContainerLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.onSecondaryLight,
      secondaryContainer: AppColors.secondaryContainerLight,
      tertiary: AppColors.tertiaryLight,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.tertiaryContainerLight,
      background: AppColors.backgroundLight,
      onBackground: AppColors.onBackgroundLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      surfaceVariant: AppColors.surfaceVariantLight,
      onSurfaceVariant: AppColors.onSurfaceVariantLight,
      outline: AppColors.outlineLight,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: baseColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTypography.getTextTheme(AppColors.onBackgroundLight),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineLight,
        thickness: 1.0,
        space: 1.0,
      ),

      // --- Component Themes ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.getTextTheme(AppColors.onSurfaceVariantLight)
            .bodyMedium
            ?.copyWith(color: AppColors.onSurfaceVariantLight.withOpacity(0.6)),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.outlineLight),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.outlineLight),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      buttonTheme: const ButtonThemeData(shape: AppRadius.shapeMd),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.onPrimaryLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          shape: AppRadius.shapeMd,
          textStyle: AppTypography.buttonTextStyle(
            color: AppColors.onPrimaryLight,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.outlineLight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          shape: AppRadius.shapeMd,
          textStyle: AppTypography.buttonTextStyle(
            color: AppColors.primaryLight,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: AppRadius.shapeSm,
          textStyle: AppTypography.buttonTextStyle(
            color: AppColors.primaryLight,
          ),
        ),
      ),

      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: AppRadius.shapeLg,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primaryContainerLight,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.onSurfaceVariantLight,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.onSurfaceVariantLight,
          );
        }),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 6,
        shape: AppRadius.shapeXl,
        titleTextStyle: AppTypography.getTextTheme(
          AppColors.onSurfaceLight,
        ).titleLarge,
        contentTextStyle: AppTypography.getTextTheme(
          AppColors.onSurfaceLight,
        ).bodyMedium,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 8,
        shape: AppRadius.shapeTopXl,
        dragHandleColor: AppColors.outlineLight,
        dragHandleSize: Size(36, 4),
        showDragHandle: true,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.secondaryLight,
        contentTextStyle: TextStyle(
          fontFamily: AppTypography.bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        actionTextColor: AppColors.primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: AppRadius.shapeSm,
        elevation: 4,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantLight,
        disabledColor: AppColors.surfaceVariantLight.withOpacity(0.4),
        selectedColor: AppColors.primaryContainerLight,
        secondarySelectedColor: AppColors.primaryContainerLight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        shape: AppRadius.shapeSm,
        side: BorderSide.none,
        brightness: Brightness.light,
        labelStyle: TextStyle(
          fontFamily: AppTypography.bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceLight,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimaryLight;
          }
          return AppColors.onSurfaceVariantLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.outlineLight;
        }),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
        circularTrackColor: AppColors.outlineLight,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: AppRadius.shapeMd,
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.primaryContainerLight,
        iconColor: AppColors.onSurfaceVariantLight,
        textColor: AppColors.onSurfaceLight,
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(false),
        trackVisibility: WidgetStateProperty.all(false),
        thickness: WidgetStateProperty.all(6),
        radius: AppRadius.radiusCircular,
      ),

      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(AppColors.surfaceVariantLight),
        shape: WidgetStateProperty.all(AppRadius.shapeMd),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
        textStyle: WidgetStateProperty.all(
          AppTypography.getTextTheme(AppColors.onSurfaceLight).bodyLarge,
        ),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(
          color: AppColors.secondaryLight,
          borderRadius: AppRadius.borderXs,
        ),
        textStyle: AppTypography.getTextTheme(Colors.white).bodySmall,
      ),

      // --- Theme Extensions Ingestion ---
      extensions: [
        AiThemeExtension(
          aiGradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          userBubbleColor: AppColors.primaryContainerLight,
          assistantBubbleColor: AppColors.surfaceVariantLight,
          glowColor: const Color(0xFFEC4899).withOpacity(0.15),
        ),
        const AnalyticsThemeExtension(
          gridLineColor: AppColors.outlineLight,
          chartLabelColor: AppColors.onSurfaceVariantLight,
          chartColors: AppColors.chartPalette,
          heatmapScale: AppColors.heatmapColors,
        ),
        const FinanceThemeExtension(
          incomeColor: AppColors.income,
          expenseColor: AppColors.expense,
          budgetProgressColor: AppColors.budget,
          budgetLimitExceededColor: AppColors.fraud,
          subscriptionCardColor: AppColors.surfaceVariantLight,
        ),
        const FraudThemeExtension(
          riskHigh: AppColors.fraud,
          riskMedium: AppColors.warning,
          riskLow: AppColors.success,
          alertBannerBackground: Color(0xFFFEF2F2),
        ),
        SecurityThemeExtension(
          biometricRingColor: AppColors.security,
          secureShieldColor: AppColors.primaryLight,
          keyboardNumberColor: AppColors.onSurfaceLight,
          pinDotActiveColor: AppColors.primaryLight,
        ),
      ],
    );
  }

  // --- Dark Theme Definition ---
  static ThemeData get darkTheme {
    final baseColorScheme = ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.onPrimaryDark,
      primaryContainer: AppColors.primaryContainerDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.onSecondaryDark,
      secondaryContainer: AppColors.secondaryContainerDark,
      tertiary: AppColors.tertiaryDark,
      onTertiary: Colors.black,
      tertiaryContainer: AppColors.tertiaryContainerDark,
      background: AppColors.backgroundDark,
      onBackground: AppColors.onBackgroundDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      surfaceVariant: AppColors.surfaceVariantDark,
      onSurfaceVariant: AppColors.onSurfaceVariantDark,
      outline: AppColors.outlineDark,
      error: AppColors.error,
      onError: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: baseColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppTypography.getTextTheme(AppColors.onBackgroundDark),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineDark,
        thickness: 1.0,
        space: 1.0,
      ),

      // --- Component Themes ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.getTextTheme(AppColors.onSurfaceVariantDark)
            .bodyMedium
            ?.copyWith(color: AppColors.onSurfaceVariantDark.withOpacity(0.6)),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.outlineDark),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.outlineDark),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      buttonTheme: const ButtonThemeData(shape: AppRadius.shapeMd),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.onSecondaryDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          shape: AppRadius.shapeMd,
          textStyle: AppTypography.buttonTextStyle(
            color: AppColors.onSecondaryDark,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.outlineDark),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          shape: AppRadius.shapeMd,
          textStyle: AppTypography.buttonTextStyle(
            color: AppColors.primaryDark,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: AppRadius.shapeSm,
          textStyle: AppTypography.buttonTextStyle(
            color: AppColors.primaryDark,
          ),
        ),
      ),

      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: AppRadius.shapeLg,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primaryContainerDark,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? AppColors.primaryDark
                : AppColors.onSurfaceVariantDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: isSelected
                ? AppColors.primaryDark
                : AppColors.onSurfaceVariantDark,
          );
        }),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 6,
        shape: AppRadius.shapeXl,
        titleTextStyle: AppTypography.getTextTheme(
          AppColors.onSurfaceDark,
        ).titleLarge,
        contentTextStyle: AppTypography.getTextTheme(
          AppColors.onSurfaceDark,
        ).bodyMedium,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 8,
        shape: AppRadius.shapeTopXl,
        dragHandleColor: AppColors.outlineDark,
        dragHandleSize: Size(36, 4),
        showDragHandle: true,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        contentTextStyle: TextStyle(
          fontFamily: AppTypography.bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceDark,
        ),
        actionTextColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: AppRadius.shapeSm,
        elevation: 4,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        disabledColor: AppColors.surfaceVariantDark.withOpacity(0.4),
        selectedColor: AppColors.primaryContainerDark,
        secondarySelectedColor: AppColors.primaryContainerDark,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        shape: AppRadius.shapeSm,
        side: BorderSide.none,
        brightness: Brightness.dark,
        labelStyle: TextStyle(
          fontFamily: AppTypography.bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceDark,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onSecondaryDark;
          }
          return AppColors.onSurfaceVariantDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return AppColors.outlineDark;
        }),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
        circularTrackColor: AppColors.outlineDark,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: AppRadius.shapeMd,
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.primaryContainerDark,
        iconColor: AppColors.onSurfaceVariantDark,
        textColor: AppColors.onSurfaceDark,
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(false),
        trackVisibility: WidgetStateProperty.all(false),
        thickness: WidgetStateProperty.all(6),
        radius: AppRadius.radiusCircular,
      ),

      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(AppColors.surfaceVariantDark),
        shape: WidgetStateProperty.all(AppRadius.shapeMd),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
        textStyle: WidgetStateProperty.all(
          AppTypography.getTextTheme(AppColors.onSurfaceDark).bodyLarge,
        ),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariantDark,
          borderRadius: AppRadius.borderXs,
        ),
        textStyle: AppTypography.getTextTheme(Colors.white).bodySmall,
      ),

      // --- Theme Extensions Ingestion ---
      extensions: [
        AiThemeExtension(
          aiGradient: const LinearGradient(
            colors: [Color(0xFF7C7FFF), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          userBubbleColor: AppColors.primaryContainerDark,
          assistantBubbleColor: AppColors.surfaceVariantDark,
          glowColor: const Color(0xFFEC4899).withOpacity(0.25),
        ),
        const AnalyticsThemeExtension(
          gridLineColor: AppColors.outlineDark,
          chartLabelColor: AppColors.onSurfaceVariantDark,
          chartColors: AppColors.chartPalette,
          heatmapScale: AppColors.heatmapColors,
        ),
        const FinanceThemeExtension(
          incomeColor: AppColors.income,
          expenseColor: AppColors.expense,
          budgetProgressColor: AppColors.budget,
          budgetLimitExceededColor: AppColors.fraud,
          subscriptionCardColor: AppColors.surfaceVariantDark,
        ),
        const FraudThemeExtension(
          riskHigh: AppColors.fraud,
          riskMedium: AppColors.warning,
          riskLow: AppColors.success,
          alertBannerBackground: Color(0xFF2C1616),
        ),
        SecurityThemeExtension(
          biometricRingColor: AppColors.security,
          secureShieldColor: AppColors.primaryDark,
          keyboardNumberColor: AppColors.onSurfaceDark,
          pinDotActiveColor: AppColors.primaryDark,
        ),
      ],
    );
  }
}
