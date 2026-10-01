import 'package:budget_engine/budget_engine.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Extension on [LocalDate] providing timezone-aware construction from [DateTime].
///
/// Example:
/// ```dart
/// final utcTime = DateTime.utc(2026, 3, 8, 7, 30);
/// final nyDate = LocalDateFromDateTime.fromDateTime(utcTime, 'America/New_York');
/// print(nyDate.toIsoString()); // '2026-03-08'
/// ```
extension LocalDateFromDateTime on LocalDate {
  static bool _initialized = false;

  /// Converts a [DateTime] into a [LocalDate] anchored in the given [timezoneName].
  ///
  /// Automatically initializes timezone database if not yet loaded.
  ///
  /// Example:
  /// ```dart
  /// final local = LocalDateFromDateTime.fromDateTime(DateTime.now(), 'Asia/Ho_Chi_Minh');
  /// ```
  static LocalDate fromDateTime(DateTime dateTime, String timezoneName) {
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
    }

    tz.Location location;
    try {
      location = tz.getLocation(timezoneName);
    } on Object catch (_) {
      location = tz.UTC;
    }

    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return LocalDate(tzDateTime.year, tzDateTime.month, tzDateTime.day);
  }
}
