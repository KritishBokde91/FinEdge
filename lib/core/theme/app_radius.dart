import 'package:flutter/material.dart';

/// Reusable border radius tokens for FinSight components.
/// Ensures consistent rounded corners for cards, buttons, fields, and sheets.
abstract class AppRadius {
  // --- Raw Radius Values ---
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double circular = 999.0;

  // --- Radius Helpers ---
  static const Radius radiusXs = Radius.circular(xs);
  static const Radius radiusSm = Radius.circular(sm);
  static const Radius radiusMd = Radius.circular(md);
  static const Radius radiusLg = Radius.circular(lg);
  static const Radius radiusXl = Radius.circular(xl);
  static const Radius radiusXxl = Radius.circular(xxl);
  static const Radius radiusCircular = Radius.circular(circular);

  // --- BorderRadius Helpers ---
  static const BorderRadius borderXs = BorderRadius.all(radiusXs);
  static const BorderRadius borderSm = BorderRadius.all(radiusSm);
  static const BorderRadius borderMd = BorderRadius.all(radiusMd);
  static const BorderRadius borderLg = BorderRadius.all(radiusLg);
  static const BorderRadius borderXl = BorderRadius.all(radiusXl);
  static const BorderRadius borderXxl = BorderRadius.all(radiusXxl);
  static const BorderRadius borderCircular = BorderRadius.all(radiusCircular);

  // --- Top/Bottom-only Rounded Border Radius ---
  static const BorderRadius borderTopMd = BorderRadius.only(
    topLeft: radiusMd,
    topRight: radiusMd,
  );
  static const BorderRadius borderTopLg = BorderRadius.only(
    topLeft: radiusLg,
    topRight: radiusLg,
  );
  static const BorderRadius borderTopXl = BorderRadius.only(
    topLeft: radiusXl,
    topRight: radiusXl,
  );
  static const BorderRadius borderTopXxl = BorderRadius.only(
    topLeft: radiusXxl,
    topRight: radiusXxl,
  );

  static const BorderRadius borderBottomMd = BorderRadius.only(
    bottomLeft: radiusMd,
    bottomRight: radiusMd,
  );
  static const BorderRadius borderBottomLg = BorderRadius.only(
    bottomLeft: radiusLg,
    bottomRight: radiusLg,
  );

  // --- RoundedRectangleBorder Configurations (Useful for Cards and Dialog shapes) ---
  static const RoundedRectangleBorder shapeXs = RoundedRectangleBorder(
    borderRadius: borderXs,
  );
  static const RoundedRectangleBorder shapeSm = RoundedRectangleBorder(
    borderRadius: borderSm,
  );
  static const RoundedRectangleBorder shapeMd = RoundedRectangleBorder(
    borderRadius: borderMd,
  );
  static const RoundedRectangleBorder shapeLg = RoundedRectangleBorder(
    borderRadius: borderLg,
  );
  static const RoundedRectangleBorder shapeXl = RoundedRectangleBorder(
    borderRadius: borderXl,
  );
  static const RoundedRectangleBorder shapeXxl = RoundedRectangleBorder(
    borderRadius: borderXxl,
  );
  static const RoundedRectangleBorder shapeCircular = RoundedRectangleBorder(
    borderRadius: borderCircular,
  );

  static const RoundedRectangleBorder shapeTopLg = RoundedRectangleBorder(
    borderRadius: borderTopLg,
  );
  static const RoundedRectangleBorder shapeTopXl = RoundedRectangleBorder(
    borderRadius: borderTopXl,
  );
}
