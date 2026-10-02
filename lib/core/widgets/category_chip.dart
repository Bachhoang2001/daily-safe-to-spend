import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Pill-shaped category chip (radius 999) with optional icon, selection indicator,
/// and support for pressed and disabled states.
class CategoryChip extends StatelessWidget {
  /// Creates a [CategoryChip].
  const CategoryChip({
    required this.label,
    super.key,
    this.icon,
    this.color,
    this.isSelected = false,
    this.enabled = true,
    this.onTap,
  });

  /// Name of the category.
  final String label;

  /// Icon representing the category.
  final IconData? icon;

  /// Brand or accent color for this category.
  final Color? color;

  /// Whether the chip is currently selected.
  final bool isSelected;

  /// Whether the chip is interactive.
  final bool enabled;

  /// Tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor =
        color ?? (isDark ? AppColors.primaryDark : AppColors.primaryLight);

    final isInteractive = enabled && onTap != null;

    final backgroundColor = isSelected
        ? effectiveColor.withValues(alpha: isDark ? 0.25 : 0.15)
        : (isDark
              ? AppColors.surfaceVariantDark
              : AppColors.surfaceVariantLight);

    final borderColor = isSelected
        ? effectiveColor
        : (isDark ? AppColors.borderDark : AppColors.borderLight);

    final contentColor = isSelected
        ? effectiveColor
        : (enabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withValues(alpha: 0.38));

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: isInteractive,
      label: label,
      child: Material(
        color: enabled
            ? backgroundColor
            : backgroundColor.withValues(alpha: 0.38),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusChip,
          side: BorderSide(
            color: enabled ? borderColor : borderColor.withValues(alpha: 0.38),
          ),
        ),
        child: InkWell(
          borderRadius: AppSpacing.borderRadiusChip,
          onTap: isInteractive
              ? () {
                  HapticFeedback.selectionClick();
                  onTap!();
                }
              : null,
          splashColor: effectiveColor.withValues(alpha: 0.15),
          highlightColor: effectiveColor.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: contentColor),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: contentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
