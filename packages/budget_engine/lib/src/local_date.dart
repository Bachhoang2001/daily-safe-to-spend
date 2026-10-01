/// An immutable calendar date without a time or timezone component (ISO-8601 YYYY-MM-DD).
///
/// Designed for purely date-based business logic (e.g. daily budgets, bill recurrence).
///
/// Example:
/// ```dart
/// const date = LocalDate(2026, 10, 1);
/// final tomorrow = date.addDays(1);
/// print(tomorrow.toIsoString()); // '2026-10-02'
/// ```
class LocalDate implements Comparable<LocalDate> {
  /// The calendar year (e.g. 2026).
  final int year;

  /// The month of the year (1 through 12).
  final int month;

  /// The day of the month (1 through 31).
  final int day;

  /// Creates a [LocalDate] with the given [year], [month], and [day].
  ///
  /// Example:
  /// ```dart
  /// const newYear = LocalDate(2026, 1, 1);
  /// ```
  const LocalDate(this.year, this.month, this.day);

  /// Parses an ISO-8601 date string formatted as `YYYY-MM-DD`.
  ///
  /// Throws a [FormatException] if the format is invalid or the date does not exist.
  ///
  /// Example:
  /// ```dart
  /// final payday = LocalDate.parse('2026-03-15');
  /// print(payday.month); // 3
  /// ```
  factory LocalDate.parse(String formatted) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(formatted);
    if (match == null) {
      throw FormatException('Invalid ISO-8601 date format: $formatted');
    }

    final y = int.parse(match.group(1)!);
    final m = int.parse(match.group(2)!);
    final d = int.parse(match.group(3)!);

    if (m < 1 || m > 12) {
      throw FormatException('Invalid month: $m in $formatted');
    }

    final maxDays = daysInMonth(y, m);
    if (d < 1 || d > maxDays) {
      throw FormatException('Invalid day: $d for month $m in $formatted');
    }

    return LocalDate(y, m, d);
  }

  /// Returns the number of days in the specified [year] and [month].
  ///
  /// Correctly handles leap years for February.
  ///
  /// Example:
  /// ```dart
  /// print(LocalDate.daysInMonth(2026, 2)); // 28
  /// print(LocalDate.daysInMonth(2028, 2)); // 29 (leap year)
  /// ```
  static int daysInMonth(int year, int month) {
    if (month == 2) {
      final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeap ? 29 : 28;
    }
    const days = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month];
  }

  /// Whether the [year] is a leap year according to the Gregorian calendar.
  ///
  /// Example:
  /// ```dart
  /// const d2026 = LocalDate(2026, 1, 1);
  /// print(d2026.isLeapYear); // false
  /// const d2028 = LocalDate(2028, 1, 1);
  /// print(d2028.isLeapYear); // true
  /// ```
  bool get isLeapYear =>
      (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  /// Number of days in this date's [month].
  ///
  /// Example:
  /// ```dart
  /// const march = LocalDate(2026, 3, 10);
  /// print(march.lastDayOfMonth); // 31
  /// ```
  int get lastDayOfMonth => daysInMonth(year, month);

  /// Day of the week (1 = Monday, ..., 7 = Sunday) matching ISO-8601 convention.
  ///
  /// Example:
  /// ```dart
  /// const date = LocalDate(2026, 10, 1); // Thursday
  /// print(date.weekday); // DateTime.thursday == 4
  /// ```
  int get weekday => DateTime.utc(year, month, day).weekday;

  /// Returns an ISO-8601 formatted string: `YYYY-MM-DD`.
  ///
  /// Example:
  /// ```dart
  /// const date = LocalDate(2026, 3, 5);
  /// print(date.toIsoString()); // '2026-03-05'
  /// ```
  String toIsoString() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  String toString() => toIsoString();

  /// Adds [days] days to this date.
  ///
  /// Example:
  /// ```dart
  /// const jan30 = LocalDate(2026, 1, 30);
  /// print(jan30.addDays(3)); // 2026-02-02
  /// ```
  LocalDate addDays(int days) {
    final dt = DateTime.utc(year, month, day).add(Duration(days: days));
    return LocalDate(dt.year, dt.month, dt.day);
  }

  /// Adds [months] months to this date.
  ///
  /// If the current [day] exceeds the number of days in the destination month,
  /// the date is clamped to the last valid day of that month (e.g. Jan 31 + 1 month = Feb 28/29).
  ///
  /// Example:
  /// ```dart
  /// const jan31 = LocalDate(2026, 1, 31);
  /// print(jan31.addMonths(1)); // 2026-02-28
  /// const jan31Leap = LocalDate(2028, 1, 31);
  /// print(jan31Leap.addMonths(1)); // 2028-02-29
  /// ```
  LocalDate addMonths(int months) {
    final totalMonths = (year * 12) + (month - 1) + months;
    final targetYear = totalMonths ~/ 12;
    final targetMonth = (totalMonths % 12) + 1;

    final maxDays = daysInMonth(targetYear, targetMonth);
    final targetDay = day > maxDays ? maxDays : day;

    return LocalDate(targetYear, targetMonth, targetDay);
  }

  /// Computes the number of days from this date until [other] (`other - this`).
  ///
  /// Positive if [other] is in the future, negative if in the past, zero if identical.
  ///
  /// Example:
  /// ```dart
  /// const d1 = LocalDate(2026, 1, 1);
  /// const d2 = LocalDate(2026, 1, 15);
  /// print(d1.daysUntil(d2)); // 14
  /// print(d2.daysUntil(d1)); // -14
  /// ```
  int daysUntil(LocalDate other) {
    final dtThis = DateTime.utc(year, month, day);
    final dtOther = DateTime.utc(other.year, other.month, other.day);
    return dtOther.difference(dtThis).inDays;
  }

  /// Whether this date is strictly before [other].
  ///
  /// Example:
  /// ```dart
  /// const today = LocalDate(2026, 3, 1);
  /// const tomorrow = LocalDate(2026, 3, 2);
  /// print(today.isBefore(tomorrow)); // true
  /// ```
  bool isBefore(LocalDate other) => compareTo(other) < 0;

  /// Whether this date is strictly after [other].
  ///
  /// Example:
  /// ```dart
  /// const today = LocalDate(2026, 3, 1);
  /// const yesterday = LocalDate(2026, 2, 28);
  /// print(today.isAfter(yesterday)); // true
  /// ```
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  /// Whether this date represents the exact same calendar day as [other].
  ///
  /// Example:
  /// ```dart
  /// const d1 = LocalDate(2026, 5, 1);
  /// const d2 = LocalDate(2026, 5, 1);
  /// print(d1.isAtSameMomentAs(d2)); // true
  /// ```
  bool isAtSameMomentAs(LocalDate other) => compareTo(other) == 0;

  /// Whether this date is strictly earlier than [other].
  bool operator <(LocalDate other) => compareTo(other) < 0;

  /// Whether this date is earlier than or equal to [other].
  bool operator <=(LocalDate other) => compareTo(other) <= 0;

  /// Whether this date is strictly later than [other].
  bool operator >(LocalDate other) => compareTo(other) > 0;

  /// Whether this date is later than or equal to [other].
  bool operator >=(LocalDate other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDate &&
          other.year == year &&
          other.month == month &&
          other.day == day);

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }
}
