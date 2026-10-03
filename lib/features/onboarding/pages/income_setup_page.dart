import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/widgets/primary_button.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/widgets/currency_picker.dart';
import 'package:safe_to_spend/features/onboarding/widgets/income_mode_step.dart';
import 'package:safe_to_spend/features/onboarding/widgets/irregular_balance_step.dart';
import 'package:safe_to_spend/features/onboarding/widgets/onboarding_progress.dart';
import 'package:safe_to_spend/features/onboarding/widgets/pay_schedule_step.dart';

/// Screen 2 of Onboarding: Income & pay schedule configuration.
class IncomeSetupPage extends GetView<OnboardingController> {
  /// Creates an [IncomeSetupPage].
  const IncomeSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Header with Progress & Currency Selector
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                child: Row(
                  children: [
                    const Expanded(child: OnboardingProgress(currentStep: 2)),
                    const SizedBox(width: AppSpacing.m),
                    Obx(
                      () => CurrencyPicker(
                        selectedCurrency: controller.draft.value.currency,
                        onChanged: controller.setCurrency,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),

              // Scrollable step forms
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Obx(() {
                    final draft = controller.draft.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IncomeModeStep(
                          selectedMode: draft.incomeMode,
                          onSelectMode: controller.selectIncomeMode,
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Divider(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                        const SizedBox(height: AppSpacing.l),
                        AnimatedSwitcher(
                          duration: disableAnimations
                              ? Duration.zero
                              : AppSpacing.durationNormal,
                          switchInCurve: AppSpacing.defaultCurve,
                          switchOutCurve: AppSpacing.defaultCurve,
                          transitionBuilder: (child, animation) {
                            final isFixed =
                                child.key == const ValueKey('fixed_step');
                            final beginOffset = isFixed
                                ? const Offset(-0.25, 0)
                                : const Offset(0.25, 0);
                            final slideAnim =
                                Tween<Offset>(
                                  begin: beginOffset,
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: AppSpacing.defaultCurve,
                                  ),
                                );
                            return SlideTransition(
                              position: slideAnim,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: draft.incomeMode == IncomeMode.fixed
                              ? PayScheduleStep(
                                  key: const ValueKey('fixed_step'),
                                  selectedFrequency: draft.payFrequency,
                                  nextPayday: draft.nextPayday,
                                  incomePerPaycheck: draft.incomePerPaycheck,
                                  firstPeriodBalance: draft.firstPeriodBalance,
                                  suggestedFirstPeriodBalance:
                                      controller.suggestedFirstPeriodBalance,
                                  allowedPaydayRange:
                                      controller.allowedPaydayRange,
                                  onSelectFrequency: controller.selectFrequency,
                                  onSelectNextPayday: controller.setNextPayday,
                                  onChangedIncome:
                                      controller.setIncomePerPaycheck,
                                  onChangedFirstPeriodBalance:
                                      controller.setFirstPeriodBalance,
                                )
                              : IrregularBalanceStep(
                                  key: const ValueKey('irregular_step'),
                                  startingBalance: draft.startingBalance,
                                  safetyHorizonDays: draft.safetyHorizonDays,
                                  onChangedBalance:
                                      controller.setStartingBalance,
                                  onSelectHorizon: controller.setHorizon,
                                ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    );
                  }),
                ),
              ),

              // Bottom Action Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => PrimaryButton(
                      label: l10n?.actionContinue ?? 'Continue',
                      onPressed: controller.canContinue
                          ? controller.submitIncomeStep
                          : null,
                    ),
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
