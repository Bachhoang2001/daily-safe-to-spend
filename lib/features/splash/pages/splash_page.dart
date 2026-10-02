import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';
import 'package:safe_to_spend/features/splash/controllers/splash_controller.dart';
import 'package:safe_to_spend/features/splash/pages/startup_error_page.dart';

/// Flutter splash screen matching the native launch background.
///
/// Seamlessly continues the brand experience and dispatches to
/// the destination route (Today or Onboarding), or displays
/// [StartupErrorPage] if an unrecoverable database or startup error occurs.
class SplashPage extends GetView<SplashController> {
  /// Creates a [SplashPage].
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.viewState.value == ViewState.error) {
        return StartupErrorPage(
          onRetry: controller.retryBootstrap,
          onContactSupport: controller.contactSupport,
          errorMessage: controller.errorMessage.value,
        );
      }

      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final l10n = AppLocalizations.of(context);
      final reduceMotion = MediaQuery.of(context).disableAnimations;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.primaryLight,
        body: Center(
          child: AnimatedOpacity(
            opacity: 1,
            duration: reduceMotion ? Duration.zero : AppSpacing.durationNormal,
            child: Semantics(
              label: l10n?.loadingApp ?? 'Loading Daily Safe-to-Spend...',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const ExcludeSemantics(
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  Text(
                    l10n?.appTitle ?? 'Daily Safe-to-Spend',
                    style: AppTextStyles.title.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
