import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/money/money_formatter.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/time/local_date_timezone.dart';
import 'package:safe_to_spend/core/widgets/primary_button.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/features/bills/widgets/bill_form_sheet.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/widgets/bill_item_card.dart';
import 'package:safe_to_spend/features/onboarding/widgets/bill_quick_chips.dart';
import 'package:safe_to_spend/features/onboarding/widgets/onboarding_progress.dart';

/// Screen 3 of Onboarding: Bills (skippable step).
class OnboardingBillsPage extends GetView<OnboardingController> {
  /// Creates an [OnboardingBillsPage].
  const OnboardingBillsPage({super.key});

  void _openBillSheet(
    BuildContext context, {
    String? suggestedName,
    OnboardingBillDraft? bill,
  }) {
    final draft = controller.draft.value;
    final today = LocalDateFromDateTime.fromDateTime(
      controller.clock.now(),
      draft.timezone,
    );

    BillFormSheet.show(
      context: context,
      currency: draft.currency,
      initialDate: today,
      suggestedName: suggestedName,
      initialBill: bill,
      onSave: (savedBill) {
        if (bill != null) {
          controller.updateDraftBill(savedBill);
        } else {
          controller.addDraftBill(savedBill);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Header with Progress indicator
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                child: Row(
                  children: [
                    Expanded(child: OnboardingProgress(currentStep: 3)),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Obx(() {
                    final draft = controller.draft.value;
                    final isFixed = draft.incomeMode == IncomeMode.fixed;
                    final title = isFixed
                        ? l10n.onboardingBillsTitleFixed
                        : l10n.onboardingBillsTitleIrregular(
                            draft.safetyHorizonDays ?? 14,
                          );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Title
                        Text(
                          title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.onboardingBillsSubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),

                        // Quick suggestion chips
                        BillQuickChips(
                          onSelected: (chipName) =>
                              _openBillSheet(context, suggestedName: chipName),
                        ),
                        const SizedBox(height: AppSpacing.l),

                        // Bills list or empty state
                        if (draft.bills.isEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.l),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceVariantDark
                                  : AppColors.surfaceVariantLight,
                              borderRadius: AppSpacing.borderRadiusCard,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Text(
                              l10n.onboardingBillsEmptyPrompt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        ] else ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: draft.bills.length,
                            itemBuilder: (context, index) {
                              final bill = draft.bills[index];
                              return BillItemCard(
                                bill: bill,
                                onDismissed: () =>
                                    controller.removeDraftBill(bill.id),
                                onTap: () =>
                                    _openBillSheet(context, bill: bill),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.m),

                          // Total before payday summary line
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.m),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceVariantDark
                                  : AppColors.surfaceVariantLight,
                              borderRadius: AppSpacing.borderRadiusCard,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.primaryDark.withValues(
                                        alpha: 0.3,
                                      )
                                    : AppColors.primaryLight.withValues(
                                        alpha: 0.3,
                                      ),
                              ),
                            ),
                            child: Text(
                              l10n.onboardingBillsTotalBeforePayday(
                                MoneyFormatter.format(
                                  controller.billsTotalBeforePayday,
                                ),
                              ),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ),
              ),

              // Bottom Actions: Continue & Skip
              Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      label: l10n.actionContinue,
                      onPressed: controller.submitBillsStep,
                    ),
                    const SizedBox(height: AppSpacing.s),
                    TextButton(
                      onPressed: controller.skipBillsStep,
                      child: Text(
                        l10n.onboardingBillsSkipForNow,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
