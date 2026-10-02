import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';

/// Screen displayed when the bootstrap or database opening sequence fails.
///
/// Provides clear user feedback, a retry mechanism, and direct access
/// to customer support via email without exposing sensitive financial details.
class StartupErrorPage extends StatelessWidget {
  /// Creates a [StartupErrorPage].
  const StartupErrorPage({
    required this.onRetry,
    required this.onContactSupport,
    this.errorMessage,
    super.key,
  });

  /// Callback invoked when user taps the "Try again" action.
  final VoidCallback onRetry;

  /// Callback invoked when user taps the "Contact support" action.
  final VoidCallback onContactSupport;

  /// Optional error description for diagnostics.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final titleText = l10n?.startupErrorTitle ?? 'Something went wrong';
    final messageText =
        l10n?.startupErrorMessage ??
        'We were unable to initialize your local database. '
            'Please try again or contact support if the issue persists.';
    final tryAgainText = l10n?.actionTryAgain ?? 'Try again';
    final contactSupportText = l10n?.actionContactSupport ?? 'Contact support';

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExcludeSemantics(
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: isDark ? AppColors.overDark : AppColors.overLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                Text(
                  titleText,
                  style: AppTextStyles.title.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  messageText,
                  style: AppTextStyles.body.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (errorMessage != null && errorMessage!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.l),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.m),
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
                      errorMessage!,
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xxl),
                ElevatedButton(
                  key: const Key('bootstrap_try_again_button'),
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.primaryDark
                        : AppColors.primaryLight,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(
                      AppSpacing.defaultButtonHeight,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusButton,
                    ),
                  ),
                  child: Text(tryAgainText, style: AppTextStyles.label),
                ),
                const SizedBox(height: AppSpacing.m),
                OutlinedButton(
                  key: const Key('bootstrap_contact_support_button'),
                  onPressed: onContactSupport,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    minimumSize: const Size.fromHeight(
                      AppSpacing.defaultButtonHeight,
                    ),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusButton,
                    ),
                  ),
                  child: Text(contactSupportText, style: AppTextStyles.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
