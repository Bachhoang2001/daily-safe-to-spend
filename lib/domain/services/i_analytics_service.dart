/// Contract for analytics event tracking and crash/error reporting.
///
/// Implementations must ensure that sensitive financial data (e.g. monetary amounts,
/// bank balances, transaction memos) are never recorded or transmitted.
abstract class IAnalyticsService {
  /// Logs an analytics event with the given [name] and optional [parameters].
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});

  /// Records an uncaught or non-fatal [error] with optional [stackTrace] and [reason].
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
  });
}
