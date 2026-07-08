import 'package:flutter/material.dart';

/// Standard spacing layout constants for FinSight.
/// Follows a strict layout spacing grid to ensure screen consistency.
abstract class AppSpacing {
  // --- Raw Spacing Constants ---
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double massive = 40.0;
  static const double jumbo = 48.0;
  static const double colossus = 64.0;

  // --- Vertical Spacing Helpers (Gap heights) ---
  static const SizedBox h4 = SizedBox(height: xs);
  static const SizedBox h8 = SizedBox(height: sm);
  static const SizedBox h12 = SizedBox(height: md);
  static const SizedBox h16 = SizedBox(height: lg);
  static const SizedBox h20 = SizedBox(height: xl);
  static const SizedBox h24 = SizedBox(height: xxl);
  static const SizedBox h32 = SizedBox(height: xxxl);
  static const SizedBox h40 = SizedBox(height: massive);
  static const SizedBox h48 = SizedBox(height: jumbo);
  static const SizedBox h64 = SizedBox(height: colossus);

  // --- Horizontal Spacing Helpers (Gap widths) ---
  static const SizedBox w4 = SizedBox(width: xs);
  static const SizedBox w8 = SizedBox(width: sm);
  static const SizedBox w12 = SizedBox(width: md);
  static const SizedBox w16 = SizedBox(width: lg);
  static const SizedBox w20 = SizedBox(width: xl);
  static const SizedBox w24 = SizedBox(width: xxl);
  static const SizedBox w32 = SizedBox(width: xxxl);
  static const SizedBox w40 = SizedBox(width: massive);
  static const SizedBox w48 = SizedBox(width: jumbo);
  static const SizedBox w64 = SizedBox(width: colossus);

  // --- Common Padding Configurations ---
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(
    horizontal: xl,
  );

  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(
    vertical: lg,
  );
}
