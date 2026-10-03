import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/pages/onboarding_result_page.dart';

import '../../../../helpers/fake_clock.dart';
import '../../../../helpers/mock_services.dart';

class MockNavigator extends Mock implements INavigator {}

class FakeBudgetProfileModel extends Fake implements BudgetProfileModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBudgetProfileModel());
    registerFallbackValue(const <Bill>[]);
    registerFallbackValue(const OnboardingDraft());
  });

  late MockAnalyticsService mockAnalytics;
  late MockNavigator mockNavigator;
  late MockSettingsRepository mockSettings;
  late MockProfileRepository mockProfileRepo;
  late MockBudgetSnapshotService mockSnapshotService;
  late MockNotificationService mockNotificationService;
  late FakeClock fakeClock;
  late OnboardingController controller;

  const normalSnapshot = BudgetSnapshot(
    safeToday: Money(4200),
    tomorrowForecast: Money(4200),
    status: BudgetStatus.onTrack,
    remainingInPeriod: Money(42000),
    daysLeftInclToday: 10,
    dailyAllowanceToday: Money(4200),
  );

  const deficitSnapshot = BudgetSnapshot(
    safeToday: Money.usd(0),
    tomorrowForecast: Money.usd(0),
    status: BudgetStatus.over,
    remainingInPeriod: Money.usd(-5000),
    daysLeftInclToday: 10,
    dailyAllowanceToday: Money.usd(0),
  );

  setUp(() {
    Get.testMode = true;
    mockAnalytics = MockAnalyticsService();
    mockNavigator = MockNavigator();
    mockSettings = MockSettingsRepository();
    mockProfileRepo = MockProfileRepository();
    mockSnapshotService = MockBudgetSnapshotService();
    mockNotificationService = MockNotificationService();
    fakeClock = FakeClock(DateTime.utc(2026, 1, 1, 12));

    when(
      () => mockAnalytics.logEvent(
        any<String>(),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});

    when(
      () =>
          mockAnalytics.recordError(any(), any(), reason: any(named: 'reason')),
    ).thenAnswer((_) async {});

    when(() => mockSettings.setString(any(), any())).thenAnswer((_) async {});
    when(() => mockSettings.getString(any())).thenAnswer((_) async => null);
    when(() => mockSettings.setBool(any(), any())).thenAnswer((_) async {});
    when(() => mockSettings.getBool(any())).thenAnswer((_) async => null);
    when(() => mockSettings.remove(any())).thenAnswer((_) async {});

    when(
      () => mockNavigator.toNamed<dynamic>(
        any(),
        arguments: any<dynamic>(named: 'arguments'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async => null);
    when(
      () => mockNavigator.offAllNamed<dynamic>(
        any(),
        arguments: any<dynamic>(named: 'arguments'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async => null);

    when(
      () => mockNotificationService.hasPermission(),
    ).thenAnswer((_) async => false);
    when(
      () => mockNotificationService.requestPermission(),
    ).thenAnswer((_) async => true);
    when(
      () => mockProfileRepo.saveOnboarding(
        profile: any(named: 'profile'),
        bills: any(named: 'bills'),
      ),
    ).thenAnswer((_) async {});

    when(() => mockSnapshotService.preview(any())).thenReturn(normalSnapshot);

    controller = OnboardingController(
      analytics: mockAnalytics,
      navigator: mockNavigator,
      settingsRepo: mockSettings,
      clock: fakeClock,
      urlLauncher: (uri) async => true,
      snapshotService: mockSnapshotService,
      profileRepo: mockProfileRepo,
      notificationService: mockNotificationService,
    );
    Get.put<OnboardingController>(controller);
  });

  tearDown(Get.reset);

  Widget buildHarness({
    ThemeData? theme,
    double textScale = 1.0,
    bool disableAnimations = false,
    Size viewport = const Size(430, 932),
  }) {
    return GetMaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(
          textScaler: TextScaler.linear(textScale),
          size: viewport,
          disableAnimations: disableAnimations,
        ),
        child: const OnboardingResultPage(),
      ),
    );
  }

  group('OnboardingResultPage Design, Accessibility & Responsiveness', () {
    testWidgets(
      'Normal state: Light mode layout renders completely with zero layout exceptions',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setPayFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        await tester.pumpWidget(buildHarness(theme: AppTheme.lightTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Step 4 of 4'), findsOneWidget);
        expect(find.text('You can spend'), findsOneWidget);
        expect(find.textContaining(r'$42'), findsWidgets);
        expect(find.text('today'), findsOneWidget);
        expect(find.textContaining('payday'), findsOneWidget);
        expect(
          find.text('Get your number every morning at 8:00?'),
          findsOneWidget,
        );
        expect(find.text('Turn on'), findsOneWidget);
        expect(find.text('Not now'), findsOneWidget);
        expect(find.text('Go to Today'), findsOneWidget);
      },
    );

    testWidgets(
      'Normal state: Dark mode layout renders completely with zero layout exceptions',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.irregular)
          ..setStartingBalance(const Money(200000))
          ..setHorizon(14);

        await tester.pumpWidget(buildHarness(theme: AppTheme.darkTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Step 4 of 4'), findsOneWidget);
        expect(find.text('You can spend'), findsOneWidget);
        expect(find.textContaining(r'$42'), findsWidgets);
        expect(find.textContaining('14 days'), findsOneWidget);
        expect(find.text('Go to Today'), findsOneWidget);
      },
    );

    testWidgets(
      'Deficit state: renders gentle deficit message and allows proceeding',
      (tester) async {
        when(
          () => mockSnapshotService.preview(any()),
        ).thenReturn(deficitSnapshot);
        controller.computePreview();

        await tester.pumpWidget(buildHarness(theme: AppTheme.lightTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(
          find.text(
            "Your bills are more than your money until payday — we'll help you track it.",
          ),
          findsOneWidget,
        );
        expect(find.text('Go to Today'), findsOneWidget);
      },
    );

    testWidgets(
      'Deficit state: Dark mode renders gentle deficit message properly',
      (tester) async {
        when(
          () => mockSnapshotService.preview(any()),
        ).thenReturn(deficitSnapshot);
        controller.computePreview();

        await tester.pumpWidget(buildHarness(theme: AppTheme.darkTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(
          find.text(
            "Your bills are more than your money until payday — we'll help you track it.",
          ),
          findsOneWidget,
        );
        expect(find.text('Go to Today'), findsOneWidget);
      },
    );

    testWidgets(
      '2.0x Dynamic Type renders without text clipping or layout overflow',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        await tester.pumpWidget(
          buildHarness(theme: AppTheme.lightTheme, textScale: 2),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Step 4 of 4'), findsOneWidget);
        expect(find.text('You can spend'), findsOneWidget);
        expect(find.text('Go to Today'), findsOneWidget);
      },
    );

    testWidgets('Reduced Motion settles to target amount on initial frame', (
      tester,
    ) async {
      controller
        ..selectIncomeMode(IncomeMode.fixed)
        ..setNextPayday(const LocalDate(2026, 1, 15));

      await tester.pumpWidget(buildHarness(disableAnimations: true));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.textContaining(r'$42'), findsWidgets);
    });

    testWidgets('Normal state Light mode golden snapshot comparison', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller
        ..selectIncomeMode(IncomeMode.fixed)
        ..setNextPayday(const LocalDate(2026, 1, 15));

      await tester.pumpWidget(
        buildHarness(theme: AppTheme.lightTheme, disableAnimations: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GetMaterialApp),
        matchesGoldenFile('goldens/result_normal_light.png'),
      );
    }, tags: ['golden']);

    testWidgets('Normal state Dark mode golden snapshot comparison', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller
        ..selectIncomeMode(IncomeMode.fixed)
        ..setNextPayday(const LocalDate(2026, 1, 15));

      await tester.pumpWidget(
        buildHarness(theme: AppTheme.darkTheme, disableAnimations: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GetMaterialApp),
        matchesGoldenFile('goldens/result_normal_dark.png'),
      );
    }, tags: ['golden']);

    testWidgets('Deficit state Light mode golden snapshot comparison', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      when(
        () => mockSnapshotService.preview(any()),
      ).thenReturn(deficitSnapshot);
      controller.computePreview();

      await tester.pumpWidget(
        buildHarness(theme: AppTheme.lightTheme, disableAnimations: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GetMaterialApp),
        matchesGoldenFile('goldens/result_deficit_light.png'),
      );
    }, tags: ['golden']);

    testWidgets('Deficit state Dark mode golden snapshot comparison', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      when(
        () => mockSnapshotService.preview(any()),
      ).thenReturn(deficitSnapshot);
      controller.computePreview();

      await tester.pumpWidget(
        buildHarness(theme: AppTheme.darkTheme, disableAnimations: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GetMaterialApp),
        matchesGoldenFile('goldens/result_deficit_dark.png'),
      );
    }, tags: ['golden']);

    testWidgets(
      'Max text scale (2.0x Dynamic Type) golden snapshot comparison',
      (tester) async {
        tester.view.physicalSize = const Size(430 * 3, 932 * 3);
        tester.view.devicePixelRatio = 3.0;

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        await tester.pumpWidget(
          buildHarness(
            theme: AppTheme.lightTheme,
            textScale: 2,
            disableAnimations: true,
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(GetMaterialApp),
          matchesGoldenFile('goldens/result_max_text_scale.png'),
        );
      },
      tags: ['golden'],
    );
  });
}
