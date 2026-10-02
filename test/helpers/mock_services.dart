import 'package:app_links/app_links.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';

/// Mock implementation of [IProfileRepository] for testing.
class MockProfileRepository extends Mock implements IProfileRepository {}

/// Mock implementation of [IAnalyticsService] for testing.
class MockAnalyticsService extends Mock implements IAnalyticsService {}

/// Mock implementation of [AppLinks] for testing.
class MockAppLinks extends Mock implements AppLinks {}
