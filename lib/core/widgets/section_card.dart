import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Container card with 20pt border radius, subtle border, optional title header,
/// and optional tap interaction.
class SectionCard extends StatelessWidget {
  /// Creates a [SectionCard].
  const SectionCard({
    required this.child,
    super.key,
    this.title,
    this.padding = const EdgeInsets.all(AppSpacing.l),
    this.trailing,
    this.onTap,
  });

  /// The content displayed inside the card.
  final Widget child;

  /// Optional card section title.
  final String? title;

  /// Optional trailing widget in the card header.
  final Widget? trailing;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardContent = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || trailing != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppSpacing.m),
          ],
          child,
        ],
      ),
    );

    return Semantics(
      container: true,
      label: title,
      child: Material(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: onTap != null
            ? InkWell(
                borderRadius: AppSpacing.borderRadiusCard,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap!();
                },
                splashColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                highlightColor: theme.colorScheme.primary.withValues(
                  alpha: 0.06,
                ),
                child: cardContent,
              )
            : cardContent,
      ),
    );
  }
}
