import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/repositories/category_repository.dart';
import 'package:safe_to_spend/data/repositories/profile_repository.dart';
import 'package:safe_to_spend/data/services/deep_link_service.dart';
import 'package:safe_to_spend/data/services/noop_analytics_service.dart';
import 'package:safe_to_spend/features/splash/controllers/splash_controller.dart';

import '../../helpers/fake_clock.dart';
import '../../helpers/fake_device_id_provider.dart';
import '../../helpers/fake_uuid_generator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late FakeClock clock;
  late FakeUuidGenerator uuid;
  late FakeDeviceIdProvider deviceIdProvider;
  late ProfileRepository profileRepo;
  late CategoryRepository categoryRepo;
  late DeepLinkService deepLinkService;
  late NoopAnalyticsService analyticsService;

  setUp(() {
    Get.testMode = true;
    db = AppDatabase(NativeDatabase.memory());
    clock = FakeClock(DateTime.utc(2026, 1, 1, 12));
    uuid = FakeUuidGenerator(prefix: 'bench-uuid');
    deviceIdProvider = FakeDeviceIdProvider(deviceId: 'device-bench-0001');

    profileRepo = ProfileRepository(
      db: db,
      clock: clock,
      uuid: uuid,
      deviceIdProvider: deviceIdProvider,
    );
    categoryRepo = CategoryRepository(
      db: db,
      clock: clock,
      uuid: uuid,
      deviceIdProvider: deviceIdProvider,
    );
    analyticsService = const NoopAnalyticsService();
    deepLinkService = DeepLinkService(
      profileRepo: profileRepo,
      analytics: analyticsService,
    );
  });

  tearDown(() async {
    Get.reset();
    await deepLinkService.dispose();
    await db.close();
  });

  group('Cold Start Benchmark (Spec 006 DoD: cold start <= 1.0s)', () {
    test(
      'DoD: Cold start from database opening, seeding, profile check to route destination <= 1.0s',
      () async {
        final stopwatch = Stopwatch()..start();

        final controller = SplashController(
          profileRepo: profileRepo,
          categoryRepo: categoryRepo,
          deepLinkService: deepLinkService,
          analytics: analyticsService,
          clock: clock,
        );

        await controller.bootstrap();

        stopwatch.stop();
        final elapsedMs = stopwatch.elapsedMilliseconds;
        // Benchmark output printed for performance verification.
        // ignore: avoid_print
        print('Cold start bootstrap benchmark: ${elapsedMs}ms');

        // Verify successful bootstrap and correct destination
        expect(controller.viewState.value, ViewState.success);
        expect(controller.destinationRoute.value, AppRoutes.onboardingWelcome);

        // Verify strict performance criteria: <= 1000ms (DoD target)
        expect(
          elapsedMs,
          lessThanOrEqualTo(1000),
          reason: 'Cold start took ${elapsedMs}ms, exceeding 1000ms target',
        );
      },
    );
  });
}
