import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/money/money_formatter.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';
import 'package:safe_to_spend/core/widgets/amount_keypad.dart';

/// Step component configuring current available balance and planning horizon for irregular income.
class IrregularBalanceStep extends StatelessWidget {
  /// Creates an [IrregularBalanceStep].
  const IrregularBalanceStep({
    required this.startingBalance,
    required this.safetyHorizonDays,
    required this.onChangedBalance,
    required this.onSelectHorizon,
    super.key,
  });

  /// Current starting balance pool.
  final Money? startingBalance;

  /// Number of days in rolling safe horizon (7, 14, 30).
  final int? safetyHorizonDays;

  /// Callback emitted when user changes balance.
  final ValueChanged<Money> onChangedBalance;

  /// Callback emitted when user selects a horizon option.
  final ValueChanged<int> onSelectHorizon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;
    final l10n = AppLocalizations.of(context);
    final formattedBalance =
        startingBalance != null && startingBalance!.cents > 0
        ? MoneyFormatter.format(startingBalance!)
        : r'$0.00';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question 1: Starting balance block
        _QuestionCard(
          title:
              l10n?.onboardingIncomeCurrentMoneyTitle ??
              'How much money do you have right now?',
          child: Semantics(
            container: true,
            label:
                '${l10n?.onboardingIncomeAvailableSpendingMoneyLabel ?? 'Available spending money'}: $formattedBalance',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.m,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark.withValues(alpha: 0.5)
                    : AppColors.surfaceVariantLight.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(AppSpacing.s + 4),
                border: Border.all(color: primaryColor, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.onboardingIncomeAvailableSpendingMoneyLabel ??
                        'Available spending money',
                    style: AppTextStyles.body.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      formattedBalance,
                      style: AppTextStyles.amountMedium.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.m),

        // Question 2: Horizon selector block
        _QuestionCard(
          title:
              l10n?.onboardingIncomePlanDaysTitle ??
              'Plan ahead for how many days?',
          child: Row(
            children: [
              Expanded(
                child: _HorizonOptionCard(
                  days: 7,
                  label: l10n?.daysCount(7) ?? '7 days',
                  isRecommended: false,
                  isSelected: safetyHorizonDays == 7,
                  onTap: () => onSelectHorizon(7),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: _HorizonOptionCard(
                  days: 14,
                  label: l10n?.daysCount(14) ?? '14 days',
                  isRecommended: true,
                  isSelected: safetyHorizonDays == 14,
                  onTap: () => onSelectHorizon(14),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: _HorizonOptionCard(
                  days: 30,
                  label: l10n?.daysCount(30) ?? '30 days',
                  isRecommended: false,
                  isSelected: safetyHorizonDays == 30,
                  onTap: () => onSelectHorizon(30),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.l),

        // ATM-style keypad
        AmountKeypad(
          initialCents: startingBalance?.cents ?? 0,
          onChanged: onChangedBalance,
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.title.copyWith(fontSize: 18)),
          const SizedBox(height: AppSpacing.m),
          child,
        ],
      ),
    );
  }
}

class _HorizonOptionCard extends StatelessWidget {
  const _HorizonOptionCard({
    required this.days,
    required this.label,
    required this.isRecommended,
    required this.isSelected,
    required this.onTap,
  });

  final int days;
  final String label;
  final bool isRecommended;
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
        ? primaryColor.withValues(alpha: 0.1)
        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label:
          '$label${isRecommended ? ", ${l10n?.recommendedBadge ?? 'Recommended'}" : ""}',
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.s + 4),
          side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(AppSpacing.s + 4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTouchTarget + 8,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.s,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isSelected
                            ? primaryColor
                            : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                      ),
                    ),
                  ),
                  if (isRecommended) ...[
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n?.recommendedBadge ?? 'Recommended',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
