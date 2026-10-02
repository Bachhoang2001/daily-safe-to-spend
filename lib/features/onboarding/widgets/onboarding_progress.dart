import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';

/// Visual progress indicator for the multi-step onboarding wizard.
class OnboardingProgress extends StatelessWidget {
  /// Creates an [OnboardingProgress] widget.
  const OnboardingProgress({
    required this.currentStep,
    super.key,
    this.totalSteps = 4,
  });

  /// The active step index (1-based, e.g. 1 for step 1 of 4).
  final int currentStep;

  /// The total number of steps in the onboarding process (defaults to 4).
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;
    final inactiveColor = isDark
        ? AppColors.surfaceVariantDark
        : AppColors.borderLight;

    final l10n = AppLocalizations.of(context);
    final stepText =
        l10n?.onboardingStepProgress(currentStep, totalSteps) ??
        'Step $currentStep of $totalSteps';

    return Semantics(
      label: stepText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber <= currentStep;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < totalSteps - 1 ? AppSpacing.xs : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted ? primaryColor : inactiveColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            stepText,
            style: AppTextStyles.caption.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
