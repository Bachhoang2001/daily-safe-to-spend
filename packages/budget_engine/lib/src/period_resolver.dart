import 'dart:math';

import 'local_date.dart';
import 'models/enums.dart';

/// A resolved pay period with inclusive [start] and [end] dates.
class PayPeriod {
  /// Inclusive start date of the period.
  final LocalDate start;

  /// Inclusive end date of the period.
  final LocalDate end;

  /// Creates an immutable [PayPeriod].
  const PayPeriod({required this.start, required this.end});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayPeriod &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'PayPeriod($start .. $end)';
}

/// Resolves the pay period containing [today] based on [payFrequency] and [payAnchorDate].
///
/// Returns a [PayPeriod] with inclusive [PayPeriod.start] and [PayPeriod.end] dates:
/// - [PayPeriod.start]: Most recent payday that is `<= today`.
/// - [PayPeriod.end]: The day immediately preceding the next payday.
///
/// ### Pay Frequencies (F02.2)
/// - **Weekly (`PayFrequency.weekly`):**
///   7-day period starting on the day of the week matching [payAnchorDate].
///   Computed via `anchor + floor(daysUntil(today) / 7) * 7`.
/// - **Biweekly (`PayFrequency.biweekly`):**
///   14-day period starting every two weeks anchored at [payAnchorDate].
///   Supports bi-directional extrapolation (forward and backward in time).
/// - **Semimonthly (`PayFrequency.semimonthly`):**
///   Fixed paydays on the 1st and 16th of each calendar month:
///   - First half: `[1st .. 15th]`
///   - Second half: `[16th .. lastDayOfMonth]`
/// - **Monthly (`PayFrequency.monthly`):**
///   Anchored to `payAnchorDate.day`. If a month has fewer days than the anchor
///   day (e.g. Day 31 in February), it automatically clamps to the month's last
///   day (28 or 29 for leap years).
PayPeriod resolvePeriod(
  PayFrequency payFrequency,
  LocalDate payAnchorDate,
  LocalDate today,
) {
  switch (payFrequency) {
    case PayFrequency.weekly:
      final diff = payAnchorDate.daysUntil(today);
      final periodIndex = (diff / 7).floor();
      final start = payAnchorDate.addDays(periodIndex * 7);
      final end = start.addDays(6);
      return PayPeriod(start: start, end: end);

    case PayFrequency.biweekly:
      final diff = payAnchorDate.daysUntil(today);
      final periodIndex = (diff / 14).floor();
      final start = payAnchorDate.addDays(periodIndex * 14);
      final end = start.addDays(13);
      return PayPeriod(start: start, end: end);

    case PayFrequency.semimonthly:
      if (today.day <= 15) {
        final start = LocalDate(today.year, today.month, 1);
        final end = LocalDate(today.year, today.month, 15);
        return PayPeriod(start: start, end: end);
      } else {
        final start = LocalDate(today.year, today.month, 16);
        final end = LocalDate(
          today.year,
          today.month,
          LocalDate.daysInMonth(today.year, today.month),
        );
        return PayPeriod(start: start, end: end);
      }

    case PayFrequency.monthly:
      final anchorDay = payAnchorDate.day;
      final maxDayThisMonth = LocalDate.daysInMonth(today.year, today.month);
      final payDayThisMonth = min(anchorDay, maxDayThisMonth);
      final payDateThisMonth = LocalDate(
        today.year,
        today.month,
        payDayThisMonth,
      );

      if (today.isAfter(payDateThisMonth) ||
          today.isAtSameMomentAs(payDateThisMonth)) {
        final start = payDateThisMonth;
        final nextYear = today.month == 12 ? today.year + 1 : today.year;
        final nextMonth = today.month == 12 ? 1 : today.month + 1;
        final maxDayNextMonth = LocalDate.daysInMonth(nextYear, nextMonth);
        final payDayNextMonth = min(anchorDay, maxDayNextMonth);
        final nextPayDate = LocalDate(nextYear, nextMonth, payDayNextMonth);
        final end = nextPayDate.addDays(-1);
        return PayPeriod(start: start, end: end);
      } else {
        final prevYear = today.month == 1 ? today.year - 1 : today.year;
        final prevMonth = today.month == 1 ? 12 : today.month - 1;
        final maxDayPrevMonth = LocalDate.daysInMonth(prevYear, prevMonth);
        final payDayPrevMonth = min(anchorDay, maxDayPrevMonth);
        final start = LocalDate(prevYear, prevMonth, payDayPrevMonth);
        final end = payDateThisMonth.addDays(-1);
        return PayPeriod(start: start, end: end);
      }
  }
}
