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
    this.nextPayday,
    this.incomePerPaycheck,
    this.firstPeriodBalance,
    this.startingBalance,
    this.safetyHorizonDays,
    this.bufferPercent = 5,
    this.rolloverMode = RolloverMode.spread,
    this.timezone = 'UTC',
    this.bills = const <OnboardingBillDraft>[],
  });

  /// Reconstructs an [OnboardingDraft] from a JSON map with safe fallbacks.
  factory OnboardingDraft.fromJson(Map<String, dynamic> json) {
    final modeStr = json['income_mode']?.toString();
    final mode =
        IncomeMode.values.where((e) => e.name == modeStr).firstOrNull ??
        IncomeMode.fixed;

    final freqStr = json['pay_frequency']?.toString();
    final freq = PayFrequency.values
        .where((e) => e.name == freqStr)
        .firstOrNull;

    final rollStr = json['rollover_mode']?.toString();
    final roll =
        RolloverMode.values.where((e) => e.name == rollStr).firstOrNull ??
        RolloverMode.spread;

    final rawCurrency = json['currency']?.toString();
    final currency = (rawCurrency != null && rawCurrency.trim().isNotEmpty)
        ? rawCurrency.trim().toUpperCase()
        : 'USD';

    int? parseCents(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    final incomeCents = parseCents(json['income_per_paycheck_cents']);
    final income = incomeCents != null ? Money(incomeCents, currency) : null;

    final firstPeriodCents = parseCents(json['first_period_balance_cents']);
    final firstPeriod = firstPeriodCents != null
        ? Money(firstPeriodCents, currency)
        : null;

    final startingCents = parseCents(json['starting_balance_cents']);
    final starting = startingCents != null
        ? Money(startingCents, currency)
        : null;

    int? parseInt(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    final billsList = <OnboardingBillDraft>[];
    if (json['bills'] is List) {
      for (final item in json['bills'] as List<dynamic>) {
        if (item is Map) {
          final billMap = Map<String, dynamic>.from(item);
          billsList.add(
            OnboardingBillDraft.fromJson(billMap, currency: currency),
          );
        }
      }
    }

    return OnboardingDraft(
      currency: currency,
      incomeMode: mode,
      payFrequency: freq,
      payAnchorDate: LocalDate.tryParse(json['pay_anchor_date']?.toString()),
      nextPayday: LocalDate.tryParse(json['next_payday']?.toString()),
      incomePerPaycheck: income,
      firstPeriodBalance: firstPeriod,
      startingBalance: starting,
      safetyHorizonDays: parseInt(json['safety_horizon_days']),
      bufferPercent: parseInt(json['buffer_percent']) ?? 5,
      rolloverMode: roll,
      timezone: json['timezone']?.toString() ?? 'UTC',
      bills: billsList,
    );
  }

  /// Currency code (ISO 4217, e.g. 'USD').
  final String currency;

  /// Income calculation model (fixed vs irregular).
  final IncomeMode incomeMode;

  /// Paycheck frequency for fixed income.
  final PayFrequency? payFrequency;

  /// Anchor payday for period calculations.
  final LocalDate? payAnchorDate;

  /// Next upcoming payday selected by the user.
  final LocalDate? nextPayday;

  /// Expected net income per paycheck.
  final Money? incomePerPaycheck;

  /// Available balance for the initial pay period until next payday.
  final Money? firstPeriodBalance;

  /// Current starting balance / pool when onboarding irregular income.
  final Money? startingBalance;

  /// Safety horizon window in days for irregular income (e.g. 7, 14, 30).
  final int? safetyHorizonDays;

  /// Safety buffer percentage (0-20%).
  final int bufferPercent;

  /// Rollover policy for unspent daily allowance.
  final RolloverMode rolloverMode;

  /// Local device timezone name (e.g. 'America/New_York', 'UTC').
  final String timezone;

  /// List of recurring bills entered during onboarding.
  final List<OnboardingBillDraft> bills;

  /// Returns a copy of this draft with the specified properties updated.
  OnboardingDraft copyWith({
    String? currency,
    IncomeMode? incomeMode,
    PayFrequency? payFrequency,
    LocalDate? payAnchorDate,
    LocalDate? nextPayday,
    Money? incomePerPaycheck,
    Money? firstPeriodBalance,
    Money? startingBalance,
    int? safetyHorizonDays,
    int? bufferPercent,
    RolloverMode? rolloverMode,
    String? timezone,
    List<OnboardingBillDraft>? bills,
    bool clearPayFrequency = false,
    bool clearPayAnchorDate = false,
    bool clearNextPayday = false,
    bool clearIncomePerPaycheck = false,
    bool clearFirstPeriodBalance = false,
    bool clearStartingBalance = false,
    bool clearSafetyHorizonDays = false,
  }) {
    return OnboardingDraft(
      currency: currency ?? this.currency,
      incomeMode: incomeMode ?? this.incomeMode,
      payFrequency: clearPayFrequency
          ? null
          : (payFrequency ?? this.payFrequency),
      payAnchorDate: clearPayAnchorDate
          ? null
          : (payAnchorDate ?? this.payAnchorDate),
      nextPayday: clearNextPayday ? null : (nextPayday ?? this.nextPayday),
      incomePerPaycheck: clearIncomePerPaycheck
          ? null
          : (incomePerPaycheck ?? this.incomePerPaycheck),
      firstPeriodBalance: clearFirstPeriodBalance
          ? null
          : (firstPeriodBalance ?? this.firstPeriodBalance),
      startingBalance: clearStartingBalance
          ? null
          : (startingBalance ?? this.startingBalance),
      safetyHorizonDays: clearSafetyHorizonDays
          ? null
          : (safetyHorizonDays ?? this.safetyHorizonDays),
      bufferPercent: bufferPercent ?? this.bufferPercent,
      rolloverMode: rolloverMode ?? this.rolloverMode,
      timezone: timezone ?? this.timezone,
      bills: bills ?? this.bills,
    );
  }

  /// Converts this draft to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'currency': currency,
      'income_mode': incomeMode.name,
      'pay_frequency': payFrequency?.name,
      'pay_anchor_date': payAnchorDate?.toIsoString(),
      'next_payday': nextPayday?.toIsoString(),
      'income_per_paycheck_cents': incomePerPaycheck?.cents,
      'first_period_balance_cents': firstPeriodBalance?.cents,
      'starting_balance_cents': startingBalance?.cents,
      'safety_horizon_days': safetyHorizonDays,
      'buffer_percent': bufferPercent,
      'rollover_mode': rolloverMode.name,
      'timezone': timezone,
      'bills': bills.map((b) => b.toJson()).toList(),
    };
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
          nextPayday == other.nextPayday &&
          incomePerPaycheck == other.incomePerPaycheck &&
          firstPeriodBalance == other.firstPeriodBalance &&
          startingBalance == other.startingBalance &&
          safetyHorizonDays == other.safetyHorizonDays &&
          bufferPercent == other.bufferPercent &&
          rolloverMode == other.rolloverMode &&
          timezone == other.timezone &&
          listEquals(bills, other.bills);

  @override
  int get hashCode => Object.hash(
    currency,
    incomeMode,
    payFrequency,
    payAnchorDate,
    nextPayday,
    incomePerPaycheck,
    firstPeriodBalance,
    startingBalance,
    safetyHorizonDays,
    bufferPercent,
    rolloverMode,
    timezone,
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

  /// Reconstructs an [OnboardingBillDraft] from a JSON map with safe fallbacks.
  factory OnboardingBillDraft.fromJson(
    Map<String, dynamic> json, {
    String currency = 'USD',
  }) {
    final recStr = json['recurrence']?.toString();
    final rec =
        BillRecurrence.values.where((e) => e.name == recStr).firstOrNull ??
        BillRecurrence.monthly;

    int parseCents(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    final cents = parseCents(json['amount_cents']);
    final date =
        LocalDate.tryParse(json['first_due_date']?.toString()) ??
        const LocalDate(2026, 1, 1);
    return OnboardingBillDraft(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      amount: Money(cents, currency),
      recurrence: rec,
      firstDueDate: date,
    );
  }

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

  /// Converts this bill draft to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amount_cents': amount.cents,
      'recurrence': recurrence.name,
      'first_due_date': firstDueDate.toIsoString(),
    };
  }

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
