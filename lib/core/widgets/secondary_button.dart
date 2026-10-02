import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Secondary action button with outline styling, haptic response, and accessibility support.
class SecondaryButton extends StatelessWidget {
  /// Creates a [SecondaryButton].
  const SecondaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
  });

  /// Text displayed on the button.
  final String label;

  /// Callback executed on tap.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = onPressed != null;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppSpacing.defaultButtonHeight,
          minWidth: AppSpacing.minTouchTarget,
        ),
        child: OutlinedButton(
          onPressed: isEnabled
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed!();
                }
              : null,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return onSurfaceColor.withValues(alpha: 0.38);
              }
              return onSurfaceColor;
            }),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: borderColor.withValues(alpha: 0.38));
              }
              return BorderSide(color: borderColor);
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return theme.colorScheme.primary.withValues(alpha: 0.08);
              }
              return null;
            }),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusButton,
              ),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.m,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: AppSpacing.s)],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
