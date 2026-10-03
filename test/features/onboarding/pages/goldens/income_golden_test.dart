import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/pages/income_setup_page.dart';

import '../../../../helpers/fake_clock.dart';
import '../../../../helpers/mock_services.dart';

class MockNavigator extends Mock implements INavigator {}

void main() {
  late MockAnalyticsService mockAnalytics;
  late MockNavigator mockNavigator;
  late MockSettingsRepository mockSettings;
  late FakeClock fakeClock;
  late OnboardingController controller;

  setUp(() {
    Get.testMode = true;
    mockAnalytics = MockAnalyticsService();
    mockNavigator = MockNavigator();
    mockSettings = MockSettingsRepository();
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
    when(() => mockSettings.remove(any())).thenAnswer((_) async {});

    when(
      () => mockNavigator.toNamed<dynamic>(
        any(),
        arguments: any<dynamic>(named: 'arguments'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async => null);

    controller = OnboardingController(
      analytics: mockAnalytics,
      navigator: mockNavigator,
      settingsRepo: mockSettings,
      clock: fakeClock,
      urlLauncher: (uri) async => true,
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
        child: const IncomeSetupPage(),
      ),
    );
  }

  group('IncomeSetupPage Design, Golden & Responsiveness', () {
    testWidgets(
      'Light mode layout renders completely with zero layout exceptions',
      (tester) async {
        await tester.pumpWidget(buildHarness(theme: AppTheme.lightTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('How do you get paid?'), findsOneWidget);
        expect(find.text('Step 2 of 4'), findsOneWidget);
        expect(find.text('Continue'), findsOneWidget);
      },
    );

    testWidgets(
      'Dark mode layout renders completely with zero layout exceptions',
      (tester) async {
        await tester.pumpWidget(buildHarness(theme: AppTheme.darkTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('How do you get paid?'), findsOneWidget);
        expect(find.text('Same amount on a schedule'), findsOneWidget);
        expect(find.text('My income varies'), findsOneWidget);
      },
    );

    testWidgets(
      '2.0x Dynamic Type renders without text clipping or layout overflow',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(theme: AppTheme.lightTheme, textScale: 2),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('How do you get paid?'), findsOneWidget);
        expect(find.text('Continue'), findsOneWidget);
      },
    );

    testWidgets('Reduced Motion disables animation delay on mode switch', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness(disableAnimations: true));
      await tester.pumpAndSettle();

      // Tap Irregular income mode
      await tester.tap(find.text('My income varies'));
      // Single pump without waiting for animation duration
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Plan ahead for how many days?'), findsOneWidget);
    });

    testWidgets('Light mode golden snapshot comparison', (tester) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller
        ..selectIncomeMode(IncomeMode.fixed)
        ..selectFrequency(PayFrequency.biweekly)
        ..setNextPayday(const LocalDate(2026, 1, 15))
        ..setIncomePerPaycheck(const Money(250000))
        ..setFirstPeriodBalance(const Money(120000));

      await tester.pumpWidget(
        buildHarness(theme: AppTheme.lightTheme, disableAnimations: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GetMaterialApp),
        matchesGoldenFile('goldens/income_light.png'),
      );
    }, tags: ['golden']);

    testWidgets('Dark mode golden snapshot comparison', (tester) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller
        ..selectIncomeMode(IncomeMode.fixed)
        ..selectFrequency(PayFrequency.biweekly)
        ..setNextPayday(const LocalDate(2026, 1, 15))
        ..setIncomePerPaycheck(const Money(250000))
        ..setFirstPeriodBalance(const Money(120000));

      await tester.pumpWidget(
        buildHarness(theme: AppTheme.darkTheme, disableAnimations: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GetMaterialApp),
        matchesGoldenFile('goldens/income_dark.png'),
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
          ..selectIncomeMode(IncomeMode.irregular)
          ..setStartingBalance(const Money(150000))
          ..setHorizon(14);

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
          matchesGoldenFile('goldens/income_max_text_scale.png'),
        );
      },
      tags: ['golden'],
    );
  });
}
