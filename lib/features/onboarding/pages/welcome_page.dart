import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';
import 'package:safe_to_spend/core/widgets/primary_button.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/widgets/onboarding_progress.dart';

/// Screen 1 of Onboarding introducing the core value proposition of Daily Safe-to-Spend.
class WelcomePage extends GetView<OnboardingController> {
  /// Creates a [WelcomePage].
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return PopScope(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.m,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (AppSpacing.m * 2),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Step Progress: 1 of 4
                        const OnboardingProgress(currentStep: 1),
                        const SizedBox(height: AppSpacing.xl),

                        // Title
                        Text(
                          l10n?.onboardingWelcomeTitle ??
                              "Know what's safe to spend today.",
                          style: AppTextStyles.title.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.8,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s),

                        // Subtitle
                        Text(
                          l10n?.onboardingWelcomeSubtitle ??
                              'One number every morning. No bank login. Your data stays on your phone.',
                          style: AppTextStyles.body.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Animated Sample Amount Card
                        const _SampleAmountCard(),
                        const SizedBox(height: AppSpacing.xl),

                        // 3 Key Value Highlights
                        _buildHighlight(
                          icon: Icons.calendar_today_rounded,
                          text:
                              l10n?.onboardingFeaturePaycheck ??
                              'Built around your paycheck',
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        _buildHighlight(
                          icon: Icons.trending_up_rounded,
                          text:
                              l10n?.onboardingFeatureIrregular ??
                              'Works with irregular income',
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        _buildHighlight(
                          icon: Icons.shield_outlined,
                          text:
                              l10n?.onboardingFeaturePrivate ??
                              'Private by design',
                          isDark: isDark,
                        ),

                        const Spacer(),
                        const SizedBox(height: AppSpacing.xl),

                        // Primary CTA: Get started
                        PrimaryButton(
                          label: l10n?.onboardingGetStarted ?? 'Get started',
                          onPressed: controller.start,
                        ),
                        const SizedBox(height: AppSpacing.m),

                        // Legal links (Privacy Policy & Terms)
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: AppSpacing.xs,
                          children: [
                            TextButton(
                              onPressed: controller.openPrivacyPolicy,
                              style: TextButton.styleFrom(
                                minimumSize: const Size(
                                  AppSpacing.minTouchTarget,
                                  AppSpacing.minTouchTarget,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.s,
                                ),
                              ),
                              child: Text(
                                l10n?.onboardingPrivacyPolicy ??
                                    'Privacy Policy',
                                style: AppTextStyles.caption.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            ExcludeSemantics(
                              child: Text(
                                '•',
                                style: AppTextStyles.caption.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: controller.openTermsOfService,
                              style: TextButton.styleFrom(
                                minimumSize: const Size(
                                  AppSpacing.minTouchTarget,
                                  AppSpacing.minTouchTarget,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.s,
                                ),
                              ),
                              child: Text(
                                l10n?.onboardingTerms ?? 'Terms of Service',
                                style: AppTextStyles.caption.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHighlight({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExcludeSemantics(
            child: Icon(
              icon,
              size: 20,
              color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
}

/// Sample balance card illustrating the Safe-to-Spend number with subtle count-up animation.
class _SampleAmountCard extends StatefulWidget {
  const _SampleAmountCard();

  @override
  State<_SampleAmountCard> createState() => _SampleAmountCardState();
}

class _SampleAmountCardState extends State<_SampleAmountCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  static const int _targetAmount = 42;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final disableAnimations =
            MediaQuery.maybeDisableAnimationsOf(context) ?? false;
        if (disableAnimations) {
          _controller.value = 1.0;
        } else {
          _controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;

    final l10n = AppLocalizations.of(context);
    final sampleLabel =
        l10n?.onboardingSampleSafeToday ?? 'safe to spend today';

    return Semantics(
      label: '\$$_targetAmount $sampleLabel',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: AppSpacing.borderRadiusCard,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    sampleLabel,
                    style: AppTextStyles.label.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final displayValue = (_animation.value * _targetAmount).round();
                return Text(
                  '\$$displayValue',
                  style: AppTextStyles.display.copyWith(
                    color: primaryColor,
                    fontSize: 48,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
