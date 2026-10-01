import 'package:safe_to_spend/core/time/clock.dart';

/// Test fake for [Clock] that allows deterministic time control in tests.
class FakeClock implements Clock {
  /// Creates a [FakeClock] initialized to [initialTime] (defaulting to 2026-01-01 12:00:00 UTC).
  FakeClock([DateTime? initialTime])
    : time = initialTime ?? DateTime.utc(2026, 1, 1, 12);

  /// Current time held by the fake clock.
  DateTime time;

  @override
  DateTime now() => time;

  /// Advances the fake clock by [duration].
  void advance(Duration duration) {
    time = time.add(duration);
  }
}
