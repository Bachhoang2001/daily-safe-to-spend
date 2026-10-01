import 'package:budget_engine/budget_engine.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';

/// Extension methods for converting between [BudgetProfileData] and [BudgetProfileModel].
extension ProfileMapper on BudgetProfileData {
  /// Converts Drift database row [BudgetProfileData] to domain [BudgetProfileModel].
  BudgetProfileModel toDomain() {
    final safeCurrency = currency.isEmpty ? 'USD' : currency;
    final safeTrackingDate =
        LocalDate.tryParse(trackingStartDate) ?? const LocalDate(2026, 1, 1);

    return BudgetProfileModel(
      id: id,
      config: BudgetConfig(
        currency: safeCurrency,
        incomeMode: _parseIncomeMode(incomeMode),
        payFrequency: _parsePayFrequency(payFrequency),
        payAnchorDate: LocalDate.tryParse(payAnchorDate),
        incomePerPaycheck: incomePerPaycheckCents != null
            ? Money(incomePerPaycheckCents!, safeCurrency)
            : null,
        firstPeriodBalance: firstPeriodBalanceCents != null
            ? Money(firstPeriodBalanceCents!, safeCurrency)
            : null,
        startingBalance: startingBalanceCents != null
            ? Money(startingBalanceCents!, safeCurrency)
            : null,
        trackingStartDate: safeTrackingDate,
        safetyHorizonDays: safetyHorizonDays < 0 ? 14 : safetyHorizonDays,
        bufferPercent: bufferPercent < 0 ? 0 : bufferPercent,
        rolloverMode: _parseRolloverMode(rolloverMode),
      ),
      timezone: timezone.isEmpty ? 'UTC' : timezone,
      weekStart: (weekStart < 1 || weekStart > 7) ? 1 : weekStart,
      onboardingCompleted: onboardingCompleted,
    );
  }
}

IncomeMode _parseIncomeMode(String value) {
  for (final mode in IncomeMode.values) {
    if (mode.name == value) return mode;
  }
  return IncomeMode.fixed;
}

PayFrequency? _parsePayFrequency(String? value) {
  if (value == null) return null;
  for (final freq in PayFrequency.values) {
    if (freq.name == value) return freq;
  }
  return null;
}

RolloverMode _parseRolloverMode(String value) {
  for (final mode in RolloverMode.values) {
    if (mode.name == value) return mode;
  }
  return RolloverMode.spread;
}
