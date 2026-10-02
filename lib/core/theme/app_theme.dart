import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';

/// Central theme definitions for light and dark modes adhering to Material 3
/// and the Daily Safe-to-Spend design system tokens.
abstract class AppTheme {
  AppTheme._();

  /// Light theme definition complying with Material 3.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primaryLight,
      primaryContainer: AppColors.primaryLight.withValues(alpha: 0.12),
      onSurface: AppColors.textPrimaryLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      surfaceContainerHighest: AppColors.surfaceVariantLight,
      outline: AppColors.borderLight,
      outlineVariant: AppColors.borderLight.withValues(alpha: 0.6),
      error: AppColors.overLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        titleLarge: AppTextStyles.title.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: AppTextStyles.body.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        labelLarge: AppTextStyles.label.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        bodySmall: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondaryLight,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title.copyWith(
          color: AppColors.textPrimaryLight,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
          side: BorderSide(color: AppColors.borderLight),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.primaryLight.withValues(alpha: 0.38);
            }
            return AppColors.primaryLight;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: 0.38);
            }
            return Colors.white;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withValues(alpha: 0.15);
            }
            return null;
          }),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSpacing.defaultButtonHeight),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusButton),
          ),
          textStyle: WidgetStatePropertyAll(
            AppTextStyles.label.copyWith(fontWeight: FontWeight.w600),
          ),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textPrimaryLight.withValues(alpha: 0.38);
            }
            return AppColors.textPrimaryLight;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: AppColors.borderLight.withValues(alpha: 0.38),
              );
            }
            return const BorderSide(color: AppColors.borderLight);
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryLight.withValues(alpha: 0.1);
            }
            return null;
          }),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSpacing.defaultButtonHeight),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusButton),
          ),
          textStyle: WidgetStatePropertyAll(
            AppTextStyles.label.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
            );
          }
          return AppTextStyles.caption.copyWith(
            color: AppColors.textSecondaryLight,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryLight);
          }
          return const IconThemeData(color: AppColors.textSecondaryLight);
        }),
      ),
    );
  }

  /// Dark theme definition complying with Material 3.
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryDark.withValues(alpha: 0.2),
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.borderDark.withValues(alpha: 0.6),
      error: AppColors.overDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: AppTextStyles.title.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: AppTextStyles.body.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        labelLarge: AppTextStyles.label.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodySmall: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
          side: BorderSide(color: AppColors.borderDark),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.primaryDark.withValues(alpha: 0.38);
            }
            return AppColors.primaryDark;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.black.withValues(alpha: 0.38);
            }
            return Colors.black;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black.withValues(alpha: 0.15);
            }
            return null;
          }),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSpacing.defaultButtonHeight),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusButton),
          ),
          textStyle: WidgetStatePropertyAll(
            AppTextStyles.label.copyWith(fontWeight: FontWeight.w600),
          ),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textPrimaryDark.withValues(alpha: 0.38);
            }
            return AppColors.textPrimaryDark;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: AppColors.borderDark.withValues(alpha: 0.38),
              );
            }
            return const BorderSide(color: AppColors.borderDark);
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryDark.withValues(alpha: 0.15);
            }
            return null;
          }),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSpacing.defaultButtonHeight),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusButton),
          ),
          textStyle: WidgetStatePropertyAll(
            AppTextStyles.label.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primaryDark.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            );
          }
          return AppTextStyles.caption.copyWith(
            color: AppColors.textSecondaryDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryDark);
          }
          return const IconThemeData(color: AppColors.textSecondaryDark);
        }),
      ),
    );
  }
}
