import 'package:flutter/material.dart';

/// Central design tokens for color across the Daily Safe-to-Spend application.
///
/// Follows Material 3 with custom brand green and calm financial status indicators.
/// Never uses aggressive pure red; overspent uses gentle terracotta (#C8553D).
abstract class AppColors {
  AppColors._();

  // Primary / Brand Green
  static const Color primaryLight = Color(0xFF2E9E6A);
  static const Color primaryDark = Color(0xFF4CC38A);

  // Status: On Track (Healthy Safe-to-Spend)
  static const Color onTrackLight = primaryLight;
  static const Color onTrackDark = primaryDark;
  static const Color onTrack = onTrackLight;

  // Status: Caution (Under 20% of daily allowance)
  static const Color cautionLight = Color(0xFFD98E04);
  static const Color cautionDark = Color(0xFFF2B544);
  static const Color caution = cautionLight;

  // Status: Over (Negative balance - calm terracotta / earth orange)
  static const Color overLight = Color(0xFFC8553D);
  static const Color overDark = Color(0xFFE07A5F);
  static const Color over = overLight;

  // Neutral Background & Surface - Light
  static const Color backgroundLight = Color(0xFFF8FAF9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFEFF2F0);
  static const Color borderLight = Color(0xFFE2E8E4);
  static const Color textPrimaryLight = Color(0xFF191C1B);
  static const Color textSecondaryLight = Color(0xFF6F7974);

  // Neutral Background & Surface - Dark
  static const Color backgroundDark = Color(0xFF111413);
  static const Color surfaceDark = Color(0xFF191C1B);
  static const Color surfaceVariantDark = Color(0xFF222624);
  static const Color borderDark = Color(0xFF2F3532);
  static const Color textPrimaryDark = Color(0xFFE1E3E1);
  static const Color textSecondaryDark = Color(0xFF89938E);
}
