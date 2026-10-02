import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/features/splash/controllers/splash_controller.dart';

import '../../../helpers/fake_clock.dart';
import '../../../helpers/mock_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockProfileRepository mockProfileRepo;
  late MockCategoryRepository mockCategoryRepo;
  late MockDeepLinkService mockDeepLinkService;
  late MockAnalyticsService mockAnalyticsService;
  late FakeClock fakeClock;
  late SplashController controller;

  setUpAll(() {
    registerFallbackValue(Uri.parse('safetospend://fallback'));
  });

  setUp(() {
    Get.testMode = true;
    mockProfileRepo = MockProfileRepository();
    mockCategoryRepo = MockCategoryRepository();
    mockDeepLinkService = MockDeepLinkService();
    mockAnalyticsService = MockAnalyticsService();
    fakeClock = FakeClock();

    when(
      () => mockCategoryRepo.seedDefaultCategories(),
    ).thenAnswer((_) async {});
    when(
      () => mockAnalyticsService.logEvent(
        any(),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockAnalyticsService.recordError(
        any(),
        any(),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async {});

    controller = SplashController(
      profileRepo: mockProfileRepo,
      categoryRepo: mockCategoryRepo,
      deepLinkService: mockDeepLinkService,
      analytics: mockAnalyticsService,
      clock: fakeClock,
    );
  });

  tearDown(Get.reset);

  group('SplashController (T05 - Bootstrap & Routing)', () {
    test('T05-1: Không có profile → điều hướng /onboarding/welcome', () async {
      when(
        () => mockProfileRepo.hasCompletedOnboarding(),
      ).thenAnswer((_) async => false);
      when(() => mockDeepLinkService.pendingDeepLink).thenReturn(null);
      when(() => mockDeepLinkService.consumePendingDeepLink()).thenReturn(null);

      await controller.bootstrap();

      expect(controller.viewState.value, ViewState.success);
      expect(controller.destinationRoute.value, AppRoutes.onboardingWelcome);
      verify(() => mockCategoryRepo.seedDefaultCategories()).called(1);
      verify(
        () => mockAnalyticsService.logEvent(
          'app_open',
          parameters: {'is_first_open': true, 'has_profile': false},
        ),
      ).called(1);
    });

    test('T05-2: Có profile hoàn chỉnh → /today (hoặc /root)', () async {
      when(
        () => mockProfileRepo.hasCompletedOnboarding(),
      ).thenAnswer((_) async => true);
      when(() => mockDeepLinkService.pendingDeepLink).thenReturn(null);
      when(() => mockDeepLinkService.consumePendingDeepLink()).thenReturn(null);

      await controller.bootstrap();

      expect(controller.viewState.value, ViewState.success);
      expect(
        controller.destinationRoute.value,
        anyOf(AppRoutes.root, '/today'),
      );
      verify(
        () => mockAnalyticsService.logEvent(
          'app_open',
          parameters: {'is_first_open': false, 'has_profile': true},
        ),
      ).called(1);
    });

    test(
      'T05-3: Lỗi DB giả lập → màn lỗi, nút Try again gọi lại bootstrap',
      () async {
        final dbException = Exception('Corrupt SQLite database file');
        when(
          () => mockCategoryRepo.seedDefaultCategories(),
        ).thenThrow(dbException);

        await controller.bootstrap();

        expect(controller.viewState.value, ViewState.error);
        expect(controller.errorMessage.value, isNotNull);
        verify(
          () => mockAnalyticsService.recordError(
            dbException,
            any(),
            reason: any(named: 'reason'),
          ),
        ).called(1);

        // Giả lập phục hồi DB và gọi lại Try again
        when(
          () => mockCategoryRepo.seedDefaultCategories(),
        ).thenAnswer((_) async {});
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => true);
        when(() => mockDeepLinkService.pendingDeepLink).thenReturn(null);
        when(
          () => mockDeepLinkService.consumePendingDeepLink(),
        ).thenReturn(null);

        await controller.retryBootstrap();

        expect(controller.viewState.value, ViewState.success);
        expect(
          controller.destinationRoute.value,
          anyOf(AppRoutes.root, '/today'),
        );
      },
    );

    test(
      'T05-4: Mở bằng deep link quick-add khi đã onboarding → Today + Quick Add mở',
      () async {
        final quickAddUri = Uri.parse('safetospend://quick-add?source=widget');
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => true);
        when(() => mockDeepLinkService.pendingDeepLink).thenReturn(quickAddUri);
        when(
          () => mockDeepLinkService.consumePendingDeepLink(),
        ).thenReturn(quickAddUri);
        when(() => mockDeepLinkService.handleUri(any())).thenReturn(null);

        await controller.bootstrap();

        expect(controller.viewState.value, ViewState.success);
        expect(
          controller.destinationRoute.value,
          anyOf(AppRoutes.root, '/today'),
        );
        expect(controller.shouldTriggerQuickAdd.value, isTrue);
        verify(() => mockDeepLinkService.consumePendingDeepLink()).called(1);
        verify(() => mockDeepLinkService.handleUri(quickAddUri)).called(1);
      },
    );

    test(
      'T05-5: Mở bằng deep link khi chưa onboarding → vào onboarding (bỏ qua deep link)',
      () async {
        final quickAddUri = Uri.parse('safetospend://quick-add?source=widget');
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => false);
        when(() => mockDeepLinkService.pendingDeepLink).thenReturn(quickAddUri);
        when(
          () => mockDeepLinkService.consumePendingDeepLink(),
        ).thenReturn(quickAddUri);

        await controller.bootstrap();

        expect(controller.viewState.value, ViewState.success);
        expect(controller.destinationRoute.value, AppRoutes.onboardingWelcome);
        expect(controller.shouldTriggerQuickAdd.value, isFalse);
        verify(() => mockDeepLinkService.consumePendingDeepLink()).called(1);
        verifyNever(() => mockDeepLinkService.handleUri(quickAddUri));
      },
    );
  });
}
