import 'package:flutter/material.dart';

/// Typography tokens for Daily Safe-to-Spend.
///
/// Ensures tabular figures are enabled for monetary values to prevent jitter
/// during count-up or rapid balance changes.
abstract class AppTextStyles {
  AppTextStyles._();

  /// Primary financial figure displayed on Today screen (56sp, bold, tabular figures).
  static const TextStyle display = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.1,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Screen and section headers (22sp, semi-bold).
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.25,
  );

  /// Standard content body text (16sp, regular).
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  /// Buttons, inputs, and chips (14sp, medium).
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.3,
  );

  /// Timestamps, hints, and subtext (12sp, regular).
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.3,
  );

  /// Monetary sub-amount (e.g. in list items or chips) with tabular figures.
  static const TextStyle amountMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
