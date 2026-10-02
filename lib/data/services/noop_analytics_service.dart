import 'package:safe_to_spend/domain/services/i_analytics_service.dart';

/// A no-op implementation of [IAnalyticsService] used as a placeholder
/// before full Firebase Analytics / Crashlytics integration in Spec 021.
class NoopAnalyticsService implements IAnalyticsService {
  /// Creates a [NoopAnalyticsService].
  const NoopAnalyticsService();

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    // No-op until Spec 021
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    // No-op until Spec 021
  }
}

/// Backward compatibility alias for [NoopAnalyticsService].
typedef NoOpAnalyticsService = NoopAnalyticsService;
