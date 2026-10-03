import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/theme/app_text_styles.dart';

/// Compact currency selector for the onboarding header.
class CurrencyPicker extends StatelessWidget {
  /// Creates a [CurrencyPicker].
  const CurrencyPicker({
    required this.selectedCurrency,
    required this.onChanged,
    super.key,
  });

  /// The currently active ISO 4217 currency code (e.g. 'USD').
  final String selectedCurrency;

  /// Callback emitted when the user selects a new currency code.
  final ValueChanged<String> onChanged;

  /// Supported currencies for user selection during onboarding.
  static const List<String> supportedCurrencies = ['USD', 'EUR', 'GBP'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final effectiveCurrency = supportedCurrencies.contains(selectedCurrency)
        ? selectedCurrency
        : 'USD';

    return Semantics(
      button: true,
      label:
          l10n?.semanticsCurrencyPicker(effectiveCurrency) ??
          'Select currency, currently $effectiveCurrency',
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceVariantDark
              : AppColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(AppSpacing.s),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: effectiveCurrency,
            icon: Icon(
              Icons.arrow_drop_down,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            dropdownColor: isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
            items: supportedCurrencies.map((c) {
              return DropdownMenuItem<String>(value: c, child: Text(c));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                onChanged(val);
              }
            },
          ),
        ),
      ),
    );
  }
}
