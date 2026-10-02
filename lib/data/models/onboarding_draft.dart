import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/foundation.dart';

/// Temporary in-memory draft representing user input during onboarding steps.
@immutable
class OnboardingDraft {
  /// Creates an instance of [OnboardingDraft].
  const OnboardingDraft({
    this.currency = 'USD',
    this.incomeMode = IncomeMode.fixed,
    this.payFrequency = PayFrequency.biweekly,
    this.payAnchorDate,
    this.incomePerPaycheck,
    this.startingBalance,
    this.bufferPercent = 5,
    this.rolloverMode = RolloverMode.spread,
    this.bills = const <OnboardingBillDraft>[],
  });

  /// Currency code (ISO 4217, e.g. 'USD').
  final String currency;

  /// Income calculation model (fixed vs irregular).
  final IncomeMode incomeMode;

  /// Paycheck frequency for fixed income.
  final PayFrequency payFrequency;

  /// Anchor payday for period calculations.
  final LocalDate? payAnchorDate;

  /// Expected net income per paycheck.
  final Money? incomePerPaycheck;

  /// Current starting balance / pool when onboarding mid-cycle or irregular.
  final Money? startingBalance;

  /// Safety buffer percentage (0-20%).
  final int bufferPercent;

  /// Rollover policy for unspent daily allowance.
  final RolloverMode rolloverMode;

  /// List of recurring bills entered during onboarding.
  final List<OnboardingBillDraft> bills;

  /// Returns a copy of this draft with the specified properties updated.
  OnboardingDraft copyWith({
    String? currency,
    IncomeMode? incomeMode,
    PayFrequency? payFrequency,
    LocalDate? payAnchorDate,
    Money? incomePerPaycheck,
    Money? startingBalance,
    int? bufferPercent,
    RolloverMode? rolloverMode,
    List<OnboardingBillDraft>? bills,
  }) {
    return OnboardingDraft(
      currency: currency ?? this.currency,
      incomeMode: incomeMode ?? this.incomeMode,
      payFrequency: payFrequency ?? this.payFrequency,
      payAnchorDate: payAnchorDate ?? this.payAnchorDate,
      incomePerPaycheck: incomePerPaycheck ?? this.incomePerPaycheck,
      startingBalance: startingBalance ?? this.startingBalance,
      bufferPercent: bufferPercent ?? this.bufferPercent,
      rolloverMode: rolloverMode ?? this.rolloverMode,
      bills: bills ?? this.bills,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingDraft &&
          runtimeType == other.runtimeType &&
          currency == other.currency &&
          incomeMode == other.incomeMode &&
          payFrequency == other.payFrequency &&
          payAnchorDate == other.payAnchorDate &&
          incomePerPaycheck == other.incomePerPaycheck &&
          startingBalance == other.startingBalance &&
          bufferPercent == other.bufferPercent &&
          rolloverMode == other.rolloverMode &&
          listEquals(bills, other.bills);

  @override
  int get hashCode => Object.hash(
    currency,
    incomeMode,
    payFrequency,
    payAnchorDate,
    incomePerPaycheck,
    startingBalance,
    bufferPercent,
    rolloverMode,
    Object.hashAll(bills),
  );
}

/// Draft item for a recurring bill entered during onboarding.
@immutable
class OnboardingBillDraft {
  /// Creates an instance of [OnboardingBillDraft].
  const OnboardingBillDraft({
    required this.id,
    required this.name,
    required this.amount,
    required this.recurrence,
    required this.firstDueDate,
  });

  /// Unique client-generated ID.
  final String id;

  /// Descriptive name of the bill (e.g. 'Rent', 'Internet').
  final String name;

  /// Bill payment amount.
  final Money amount;

  /// Recurrence cycle.
  final BillRecurrence recurrence;

  /// Next due date.
  final LocalDate firstDueDate;

  /// Returns a copy of this bill draft with the specified properties updated.
  OnboardingBillDraft copyWith({
    String? id,
    String? name,
    Money? amount,
    BillRecurrence? recurrence,
    LocalDate? firstDueDate,
  }) {
    return OnboardingBillDraft(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      recurrence: recurrence ?? this.recurrence,
      firstDueDate: firstDueDate ?? this.firstDueDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingBillDraft &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          amount == other.amount &&
          recurrence == other.recurrence &&
          firstDueDate == other.firstDueDate;

  @override
  int get hashCode => Object.hash(id, name, amount, recurrence, firstDueDate);
}
