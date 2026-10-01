import '../local_date.dart';
import '../money.dart';
import 'enums.dart';

/// Immutable configuration parameters governing the budget calculation.
class BudgetConfig {
  /// ISO-4217 currency code (e.g. 'USD', 'EUR').
  final String currency;

  /// Income calculation mode ([IncomeMode.fixed] or [IncomeMode.irregular]).
  final IncomeMode incomeMode;

  /// Paycheck recurrence frequency in fixed income mode.
  final PayFrequency? payFrequency;

  /// Known payday anchor in fixed income mode.
  final LocalDate? payAnchorDate;

  /// Expected net income per recurring paycheck in fixed mode.
  final Money? incomePerPaycheck;

  /// Optional initial cash balance available when onboarding mid-period.
  final Money? firstPeriodBalance;

  /// Initial liquid cash balance when starting tracking in irregular mode.
  final Money? startingBalance;

  /// Date when expense tracking begins.
  final LocalDate trackingStartDate;

  /// Rolling forward-looking safety horizon in days for irregular mode (default 14).
  final int safetyHorizonDays;

  /// Percentage of income/balance reserved as safety buffer (0 to 20%).
  final int bufferPercent;

  /// Surplus and deficit redistribution policy ([RolloverMode.spread], tomorrow, save).
  final RolloverMode rolloverMode;

  /// Creates an immutable [BudgetConfig].
  const BudgetConfig({
    this.currency = 'USD',
    required this.incomeMode,
    this.payFrequency,
    this.payAnchorDate,
    this.incomePerPaycheck,
    this.firstPeriodBalance,
    this.startingBalance,
    required this.trackingStartDate,
    this.safetyHorizonDays = 14,
    this.bufferPercent = 0,
    this.rolloverMode = RolloverMode.spread,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetConfig &&
          runtimeType == other.runtimeType &&
          currency == other.currency &&
          incomeMode == other.incomeMode &&
          payFrequency == other.payFrequency &&
          payAnchorDate == other.payAnchorDate &&
          incomePerPaycheck == other.incomePerPaycheck &&
          firstPeriodBalance == other.firstPeriodBalance &&
          startingBalance == other.startingBalance &&
          trackingStartDate == other.trackingStartDate &&
          safetyHorizonDays == other.safetyHorizonDays &&
          bufferPercent == other.bufferPercent &&
          rolloverMode == other.rolloverMode;

  @override
  int get hashCode => Object.hash(
    currency,
    incomeMode,
    payFrequency,
    payAnchorDate,
    incomePerPaycheck,
    firstPeriodBalance,
    startingBalance,
    trackingStartDate,
    safetyHorizonDays,
    bufferPercent,
    rolloverMode,
  );

  @override
  String toString() =>
      'BudgetConfig(currency: $currency, mode: $incomeMode, freq: $payFrequency, anchor: $payAnchorDate)';
}
