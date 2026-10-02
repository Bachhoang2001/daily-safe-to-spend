import 'package:flutter/material.dart';

/// Spacing, corner radius, and layout tokens.
abstract class AppSpacing {
  AppSpacing._();

  // Spacing
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Corner Radii
  static const double radiusCard = 20;
  static const double radiusButton = 14;
  static const double radiusChip = 999;
  static const double radiusBottomSheet = 24;

  static const BorderRadius borderRadiusCard = BorderRadius.all(
    Radius.circular(radiusCard),
  );
  static const BorderRadius borderRadiusButton = BorderRadius.all(
    Radius.circular(radiusButton),
  );
  static const BorderRadius borderRadiusChip = BorderRadius.all(
    Radius.circular(radiusChip),
  );
  static const BorderRadius borderRadiusBottomSheet = BorderRadius.vertical(
    top: Radius.circular(radiusBottomSheet),
  );

  // Accessibility / Touch target size
  static const double minTouchTarget = 44;
  static const double defaultButtonHeight = 48;

  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);

  // Easing
  static const Curve defaultCurve = Curves.easeOutCubic;
}
