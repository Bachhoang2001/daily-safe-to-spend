import 'package:app_links/app_links.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/domain/repositories/i_category_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_settings_repository.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';
import 'package:safe_to_spend/domain/services/i_budget_snapshot_service.dart';
import 'package:safe_to_spend/domain/services/i_deep_link_service.dart';
import 'package:safe_to_spend/domain/services/i_notification_service.dart';

/// Mock implementation of [IProfileRepository] for testing.
class MockProfileRepository extends Mock implements IProfileRepository {}

/// Mock implementation of [IAnalyticsService] for testing.
class MockAnalyticsService extends Mock implements IAnalyticsService {}

/// Mock implementation of [AppLinks] for testing.
class MockAppLinks extends Mock implements AppLinks {}

/// Mock implementation of [IDeepLinkService] for testing.
class MockDeepLinkService extends Mock implements IDeepLinkService {}

/// Mock implementation of [ICategoryRepository] for testing.
class MockCategoryRepository extends Mock implements ICategoryRepository {}

/// Mock implementation of [ISettingsRepository] for testing.
class MockSettingsRepository extends Mock implements ISettingsRepository {}

/// Mock implementation of [IBudgetSnapshotService] for testing.
class MockBudgetSnapshotService extends Mock
    implements IBudgetSnapshotService {}

/// Mock implementation of [INotificationService] for testing.
class MockNotificationService extends Mock implements INotificationService {}
