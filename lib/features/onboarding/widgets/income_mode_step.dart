import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';

/// Step component displaying the primary income calculation model question.
class IncomeModeStep extends StatelessWidget {
  /// Creates an [IncomeModeStep].
  const IncomeModeStep({
    required this.selectedMode,
    required this.onSelectMode,
    super.key,
  });

  /// The currently selected income mode.
  final IncomeMode selectedMode;

  /// Callback emitted when the user selects an income mode.
  final ValueChanged<IncomeMode> onSelectMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.onboardingIncomeHowPaidTitle ?? 'How do you get paid?',
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSpacing.m),
        _ModeSelectionCard(
          title:
              l10n?.onboardingIncomeModeFixedTitle ??
              'Same amount on a schedule',
          subtitle:
              l10n?.onboardingIncomeModeFixedSubtitle ??
              'Salary, hourly with predictable shifts, or regular pensions',
          icon: Icons.calendar_month_rounded,
          isSelected: selectedMode == IncomeMode.fixed,
          onTap: () => onSelectMode(IncomeMode.fixed),
        ),
        const SizedBox(height: AppSpacing.m),
        _ModeSelectionCard(
          title: l10n?.onboardingIncomeModeIrregularTitle ?? 'My income varies',
          subtitle:
              l10n?.onboardingIncomeModeIrregularSubtitle ??
              'Freelance, gig worker, tips, or unpredictable commissions',
          icon: Icons.trending_up_rounded,
          isSelected: selectedMode == IncomeMode.irregular,
          onTap: () => onSelectMode(IncomeMode.irregular),
        ),
      ],
    );
  }
}

class _ModeSelectionCard extends StatelessWidget {
  const _ModeSelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;
    final borderColor = isSelected
        ? primaryColor
        : (isDark ? AppColors.borderDark : AppColors.borderLight);
    final bgColor = isSelected
        ? primaryColor.withValues(alpha: 0.08)
        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title. $subtitle',
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
          side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: AppSpacing.borderRadiusCard,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.15)
                        : (isDark
                              ? AppColors.surfaceVariantDark
                              : AppColors.surfaceVariantLight),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? primaryColor
                        : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
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
