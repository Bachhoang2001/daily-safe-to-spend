import 'dart:async';

import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/money/money_formatter.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';
import 'package:safe_to_spend/core/widgets/amount_keypad.dart';
import 'package:safe_to_spend/data/models/date_range.dart';

/// Which amount input field is currently active for [AmountKeypad] entry.
enum ActiveAmountField {
  /// User is entering income per paycheck.
  incomePerPaycheck,

  /// User is entering available balance until next payday.
  firstPeriodBalance,
}

/// Step component configuring paycheck frequency, next payday date, and amounts.
class PayScheduleStep extends StatefulWidget {
  /// Creates a [PayScheduleStep].
  const PayScheduleStep({
    required this.selectedFrequency,
    required this.nextPayday,
    required this.incomePerPaycheck,
    required this.firstPeriodBalance,
    required this.suggestedFirstPeriodBalance,
    required this.allowedPaydayRange,
    required this.onSelectFrequency,
    required this.onSelectNextPayday,
    required this.onChangedIncome,
    required this.onChangedFirstPeriodBalance,
    super.key,
  });

  /// The active frequency (Weekly, Biweekly, Semimonthly, Monthly).
  final PayFrequency? selectedFrequency;

  /// The chosen next upcoming payday.
  final LocalDate? nextPayday;

  /// Net income amount per paycheck.
  final Money? incomePerPaycheck;

  /// Available spending balance for initial period.
  final Money? firstPeriodBalance;

  /// System-calculated suggested initial period balance.
  final Money? suggestedFirstPeriodBalance;

  /// Allowed selectable range for payday date picker.
  final DateRange allowedPaydayRange;

  /// Callback when a frequency is selected.
  final ValueChanged<PayFrequency> onSelectFrequency;

  /// Callback when a payday date is chosen.
  final ValueChanged<LocalDate> onSelectNextPayday;

  /// Callback when income per paycheck changes.
  final ValueChanged<Money> onChangedIncome;

  /// Callback when initial period balance changes.
  final ValueChanged<Money> onChangedFirstPeriodBalance;

  @override
  State<PayScheduleStep> createState() => _PayScheduleStepState();
}

class _PayScheduleStepState extends State<PayScheduleStep> {
  ActiveAmountField _activeField = ActiveAmountField.incomePerPaycheck;

  Future<void> _pickPayday(BuildContext context) async {
    unawaited(HapticFeedback.lightImpact());
    final startDt = DateTime(
      widget.allowedPaydayRange.start.year,
      widget.allowedPaydayRange.start.month,
      widget.allowedPaydayRange.start.day,
    );
    final endDt = DateTime(
      widget.allowedPaydayRange.end.year,
      widget.allowedPaydayRange.end.month,
      widget.allowedPaydayRange.end.day,
    );

    final initialDt = widget.nextPayday != null
        ? DateTime(
            widget.nextPayday!.year,
            widget.nextPayday!.month,
            widget.nextPayday!.day,
          )
        : startDt;

    final effectiveInitial = initialDt.isBefore(startDt)
        ? startDt
        : (initialDt.isAfter(endDt) ? endDt : initialDt);

    final picked = await showDatePicker(
      context: context,
      initialDate: effectiveInitial,
      firstDate: startDt,
      lastDate: endDt,
    );

    if (picked != null) {
      widget.onSelectNextPayday(
        LocalDate(picked.year, picked.month, picked.day),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question 1: Frequency
        _QuestionCard(
          title:
              l10n?.onboardingIncomeFrequencyTitle ?? 'How often are you paid?',
          child: Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              _FrequencyChip(
                label: l10n?.frequencyWeekly ?? 'Weekly',
                isSelected: widget.selectedFrequency == PayFrequency.weekly,
                onTap: () => widget.onSelectFrequency(PayFrequency.weekly),
              ),
              _FrequencyChip(
                label: l10n?.frequencyBiweekly ?? 'Every 2 weeks',
                isSelected: widget.selectedFrequency == PayFrequency.biweekly,
                onTap: () => widget.onSelectFrequency(PayFrequency.biweekly),
              ),
              _FrequencyChip(
                label: l10n?.frequencySemimonthly ?? 'Twice a month',
                isSelected:
                    widget.selectedFrequency == PayFrequency.semimonthly,
                onTap: () => widget.onSelectFrequency(PayFrequency.semimonthly),
              ),
              _FrequencyChip(
                label: l10n?.frequencyMonthly ?? 'Monthly',
                isSelected: widget.selectedFrequency == PayFrequency.monthly,
                onTap: () => widget.onSelectFrequency(PayFrequency.monthly),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.m),

        // Question 2: Payday Date Picker
        _QuestionCard(
          title:
              l10n?.onboardingIncomeNextPaydayTitle ??
              'When is your next payday?',
          child: Semantics(
            button: true,
            label:
                l10n?.semanticsSelectPayday(
                  widget.nextPayday?.toIsoString() ?? 'none',
                ) ??
                'Select upcoming payday date',
            child: Material(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.s + 4),
                side: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: InkWell(
                onTap: () => _pickPayday(context),
                borderRadius: BorderRadius.circular(AppSpacing.s + 4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m,
                    vertical: AppSpacing.m,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: primaryColor,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Text(
                          widget.nextPayday != null
                              ? widget.nextPayday!.toIsoString()
                              : (l10n?.onboardingIncomeSelectPaydayPlaceholder ??
                                    'Select upcoming payday'),
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: widget.nextPayday != null
                                ? (isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight)
                                : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Icon(
                        Icons.chevron_right,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.m),

        // Question 3: Income amount
        _QuestionCard(
          title:
              l10n?.onboardingIncomeTakeHomeTitle ??
              'How much do you take home each paycheck?',
          child: _AmountDisplayTile(
            label:
                l10n?.onboardingIncomeNetIncomeLabel ??
                'Net income per paycheck',
            amount: widget.incomePerPaycheck,
            isActive: _activeField == ActiveAmountField.incomePerPaycheck,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _activeField = ActiveAmountField.incomePerPaycheck;
              });
            },
          ),
        ),

        const SizedBox(height: AppSpacing.m),

        // Question 4: First period spending balance
        _QuestionCard(
          title:
              l10n?.onboardingIncomeSpendUntilTitle ??
              'How much do you have to spend until then?',
          subtitle: widget.suggestedFirstPeriodBalance != null
              ? (l10n?.onboardingIncomeSuggestedBalance(
                      MoneyFormatter.format(
                        widget.suggestedFirstPeriodBalance!,
                      ),
                    ) ??
                    'Suggested: ${MoneyFormatter.format(widget.suggestedFirstPeriodBalance!)} based on remaining days')
              : null,
          child: _AmountDisplayTile(
            label:
                l10n?.onboardingIncomeInitialBalanceLabel ??
                'Spending balance for initial period',
            amount: widget.firstPeriodBalance,
            isActive: _activeField == ActiveAmountField.firstPeriodBalance,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _activeField = ActiveAmountField.firstPeriodBalance;
              });
            },
          ),
        ),

        const SizedBox(height: AppSpacing.l),

        // ATM-style Keypad
        AmountKeypad(
          initialCents: _activeField == ActiveAmountField.incomePerPaycheck
              ? (widget.incomePerPaycheck?.cents ?? 0)
              : (widget.firstPeriodBalance?.cents ?? 0),
          onChanged: (money) {
            if (_activeField == ActiveAmountField.incomePerPaycheck) {
              widget.onChangedIncome(money);
            } else {
              widget.onChangedFirstPeriodBalance(money);
            }
          },
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;

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
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.m),
          child,
        ],
      ),
    );
  }
}

class _FrequencyChip extends StatelessWidget {
  const _FrequencyChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppSpacing.minTouchTarget,
          minWidth: AppSpacing.minTouchTarget,
        ),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) {
            HapticFeedback.selectionClick();
            onTap();
          },
          selectedColor: primaryColor.withValues(alpha: 0.15),
          labelStyle: AppTextStyles.caption.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? primaryColor
                : (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }
}

class _AmountDisplayTile extends StatelessWidget {
  const _AmountDisplayTile({
    required this.label,
    required this.amount,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final Money? amount;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;
    final formattedAmount = amount != null && amount!.cents > 0
        ? MoneyFormatter.format(amount!)
        : r'$0.00';

    return Semantics(
      button: true,
      selected: isActive,
      label: '$label: $formattedAmount',
      child: Material(
        color: isActive
            ? primaryColor.withValues(alpha: 0.06)
            : (isDark
                  ? AppColors.surfaceVariantDark.withValues(alpha: 0.4)
                  : AppColors.surfaceVariantLight.withValues(alpha: 0.6)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.s + 4),
          side: BorderSide(
            color: isActive
                ? primaryColor
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isActive ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.s + 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.m,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      formattedAmount,
                      style: AppTextStyles.amountMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? primaryColor
                            : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                      ),
                    ),
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
