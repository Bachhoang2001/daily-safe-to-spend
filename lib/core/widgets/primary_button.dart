import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Primary call-to-action button with loading state, haptic feedback, and accessibility support.
class PrimaryButton extends StatelessWidget {
  /// Creates a [PrimaryButton].
  const PrimaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  /// Text displayed on the button.
  final String label;

  /// Callback executed on tap. If null or [isLoading] is true, the button is disabled.
  final VoidCallback? onPressed;

  /// Whether to display a centered progress indicator instead of the label.
  final bool isLoading;

  /// Optional leading icon.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = onPressed != null && !isLoading;
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = isDark ? Colors.black : Colors.white;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppSpacing.defaultButtonHeight,
          minWidth: AppSpacing.minTouchTarget,
        ),
        child: ElevatedButton(
          onPressed: isEnabled
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed!();
                }
              : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return primaryColor.withValues(alpha: 0.38);
              }
              return primaryColor;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return onPrimaryColor.withValues(alpha: 0.38);
              }
              return onPrimaryColor;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return onPrimaryColor.withValues(alpha: 0.15);
              }
              return null;
            }),
            elevation: const WidgetStatePropertyAll(0),
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
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(onPrimaryColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: AppSpacing.s),
                    ],
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
