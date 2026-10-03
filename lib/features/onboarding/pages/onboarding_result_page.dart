import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';
import 'package:safe_to_spend/core/widgets/amount_text.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';

/// Onboarding Step 4: Result reveal & notification permission request.
class OnboardingResultPage extends StatefulWidget {
  /// Creates an [OnboardingResultPage].
  const OnboardingResultPage({super.key});

  @override
  State<OnboardingResultPage> createState() => _OnboardingResultPageState();
}

class _OnboardingResultPageState extends State<OnboardingResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Get.find<OnboardingController>().computePreview();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;
    final backgroundColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final stepLabel = l10n?.onboardingStepProgress(4, 4) ?? 'Step 4 of 4';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withValues(alpha: isDark ? 0.14 : 0.08),
                backgroundColor,
              ],
              stops: const [0.0, 0.45],
            ),
          ),
          child: Column(
            children: [
              // Top Progress Header (Step 4 of 4)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.s,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: stepLabel,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 1,
                          minHeight: 4,
                          backgroundColor: borderColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      stepLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Result Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.l,
                  ),
                  child: Obx(() {
                    final snapshot =
                        controller.previewSnapshot.value ??
                        controller.computePreview();
                    final draft = controller.draft.value;
                    final targetCents = snapshot.safeToday.cents;
                    final isDeficit =
                        snapshot.status == BudgetStatus.over ||
                        targetCents <= 0;

                    // Formulated subtitle text with localization
                    String subtitleText;
                    if (draft.incomeMode == IncomeMode.fixed &&
                        draft.nextPayday != null) {
                      final payday = draft.nextPayday!;
                      final dateFormatted = DateFormat(
                        'MMM d',
                      ).format(DateTime(payday.year, payday.month, payday.day));
                      subtitleText =
                          l10n?.onboardingResultSubtitleFixed(dateFormatted) ??
                          "That's your daily number until payday on $dateFormatted.";
                    } else {
                      final days = draft.safetyHorizonDays ?? 14;
                      subtitleText =
                          l10n?.onboardingResultSubtitleIrregular(days) ??
                          "That's your daily number for the next $days days.";
                    }

                    return Column(
                      children: [
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          l10n?.onboardingResultYouCanSpend ?? 'You can spend',
                          style: AppTextStyles.title.copyWith(
                            color: textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s),

                        // Animated Large Number Display (display style with tabular figures)
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, _) {
                            final currentCents = disableAnimations
                                ? targetCents
                                : (_animation.value * targetCents).round();
                            final animatedAmount = Money(
                              currentCents,
                              draft.currency,
                            );

                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: AmountText(
                                amount: animatedAmount,
                                status: isDeficit
                                    ? BudgetStatus.over
                                    : BudgetStatus.onTrack,
                                style: AppTextStyles.display,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n?.onboardingResultToday ?? 'today',
                          style: AppTextStyles.title.copyWith(
                            color: textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.m),

                        // Subtitle
                        Text(
                          subtitleText,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: textSecondary,
                          ),
                        ),

                        // Gentle Deficit Message Banner (T09-5)
                        if (isDeficit) ...[
                          const SizedBox(height: AppSpacing.l),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.m),
                            decoration: BoxDecoration(
                              color:
                                  (isDark
                                          ? AppColors.overDark
                                          : AppColors.overLight)
                                      .withValues(alpha: isDark ? 0.15 : 0.09),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusCard,
                              ),
                              border: Border.all(
                                color:
                                    (isDark
                                            ? AppColors.overDark
                                            : AppColors.overLight)
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: isDark
                                      ? AppColors.overDark
                                      : AppColors.overLight,
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.s),
                                Expanded(
                                  child: Text(
                                    l10n?.onboardingResultDeficitMessage ??
                                        "Your bills are more than your money until payday — we'll help you track it.",
                                    style: AppTextStyles.caption.copyWith(
                                      color: isDark
                                          ? AppColors.overDark
                                          : AppColors.overLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: AppSpacing.xl),

                        // Notification Pre-prompt Card (T09-4)
                        if (!controller.notificationPromptHandled.value) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.l),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusCard,
                              ),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withValues(
                                          alpha: 0.12,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.notifications_active_outlined,
                                        color: primaryColor,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.s),
                                    Expanded(
                                      child: Text(
                                        l10n?.onboardingResultNotificationTitle ??
                                            'Get your number every morning at 8:00?',
                                        style: AppTextStyles.label.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.s),
                                Text(
                                  l10n?.onboardingResultNotificationSubtitle ??
                                      "A gentle daily reminder so you always know what's safe to spend.",
                                  style: AppTextStyles.caption.copyWith(
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.m),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: AppSpacing.s,
                                    runSpacing: AppSpacing.s,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          minimumSize: const Size(
                                            AppSpacing.minTouchTarget,
                                            AppSpacing.minTouchTarget,
                                          ),
                                        ),
                                        onPressed: controller.skipNotifications,
                                        child: Text(
                                          l10n?.onboardingResultNotificationNotNow ??
                                              'Not now',
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(
                                            AppSpacing.minTouchTarget,
                                            AppSpacing.defaultButtonHeight,
                                          ),
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSpacing.radiusButton,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            controller.requestNotifications,
                                        child: Text(
                                          l10n?.onboardingResultNotificationTurnOn ??
                                              'Turn on',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.l),
                        ],
                      ],
                    );
                  }),
                ),
              ),

              // Bottom Actions: Error State Retry or "Go to Today" CTA
              Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Obx(() {
                  final isError = controller.state.value == ViewState.error;
                  final isSaving = controller.isSaving.value;

                  if (isError) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.errorMessage.value ??
                              l10n?.onboardingResultSaveError ??
                              'Failed to save profile',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.overLight,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.s),
                        SizedBox(
                          width: double.infinity,
                          height: AppSpacing.defaultButtonHeight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusButton,
                                ),
                              ),
                            ),
                            onPressed: controller.completeOnboarding,
                            child: Text(l10n?.actionTryAgain ?? 'Try again'),
                          ),
                        ),
                      ],
                    );
                  }

                  return SizedBox(
                    width: double.infinity,
                    height: AppSpacing.defaultButtonHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusButton,
                          ),
                        ),
                      ),
                      onPressed: isSaving
                          ? null
                          : controller.completeOnboarding,
                      child: isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              l10n?.onboardingResultGoToToday ?? 'Go to Today',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
