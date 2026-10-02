import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';

/// Small pill badge indicating a premium / PRO feature.
class PremiumBadge extends StatelessWidget {
  /// Creates a [PremiumBadge].
  const PremiumBadge({super.key, this.label = 'PRO'});

  /// Text displayed inside the badge.
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = isDark ? AppColors.cautionDark : AppColors.cautionLight;

    return Semantics(
      label: '$label feature',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.15),
          borderRadius: AppSpacing.borderRadiusChip,
          border: Border.all(color: badgeColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: badgeColor,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
