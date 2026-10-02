import 'package:safe_to_spend/domain/services/i_analytics_service.dart';

/// No-op implementation of [IAnalyticsService] used for development, testing,
/// and placeholder until Firebase/PostHog analytics is configured in Spec 021.
class NoOpAnalyticsService implements IAnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    // Intentionally no-op
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    // Intentionally no-op
  }
}
