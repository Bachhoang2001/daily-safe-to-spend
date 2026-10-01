/// An abstraction over system time allowing deterministic testing across controllers and services.
///
/// Example:
/// ```dart
/// class MyController {
///   final Clock clock;
///   MyController({required this.clock});
///
///   DateTime get currentTime => clock.now();
/// }
/// ```
abstract class Clock {
  /// Returns the current [DateTime].
  DateTime now();
}

/// Production implementation of [Clock] returning the real system [DateTime.now].
///
/// Example:
/// ```dart
/// const clock = SystemClock();
/// final now = clock.now();
/// ```
class SystemClock implements Clock {
  /// Creates a [SystemClock].
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
