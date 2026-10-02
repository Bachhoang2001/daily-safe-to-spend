import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/pages/welcome_page.dart';

import '../../../../helpers/mock_services.dart';

class MockNavigator extends Mock implements INavigator {}

void main() {
  late MockAnalyticsService mockAnalytics;
  late MockNavigator mockNavigator;
  late MockSettingsRepository mockSettings;
  late OnboardingController controller;

  setUp(() {
    Get.testMode = true;
    mockAnalytics = MockAnalyticsService();
    mockNavigator = MockNavigator();
    mockSettings = MockSettingsRepository();

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
        child: const WelcomePage(),
      ),
    );
  }

  group('WelcomePage Design & Responsiveness (T06-3)', () {
    testWidgets(
      'T06-3: Light mode layout renders completely with zero layout exceptions',
      (tester) async {
        await tester.pumpWidget(buildHarness(theme: AppTheme.lightTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text("Know what's safe to spend today."), findsOneWidget);
        expect(find.text('Get started'), findsOneWidget);
        expect(find.text('Privacy Policy'), findsOneWidget);
        expect(find.text('Terms of Service'), findsOneWidget);
      },
    );

    testWidgets(
      'T06-3: Dark mode layout renders completely with zero layout exceptions',
      (tester) async {
        await tester.pumpWidget(buildHarness(theme: AppTheme.darkTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text("Know what's safe to spend today."), findsOneWidget);
        expect(find.text('Built around your paycheck'), findsOneWidget);
        expect(find.text('Works with irregular income'), findsOneWidget);
        expect(find.text('Private by design'), findsOneWidget);
      },
    );

    testWidgets(
      'T06-3: 2.0x Dynamic Type renders without text clipping or layout overflow',
      (tester) async {
        await tester.pumpWidget(
          buildHarness(theme: AppTheme.lightTheme, textScale: 2),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text("Know what's safe to spend today."), findsOneWidget);
        expect(find.text('Get started'), findsOneWidget);
      },
    );

    testWidgets(
      'T06-3: Reduced Motion immediately settles sample card to final value',
      (tester) async {
        await tester.pumpWidget(buildHarness(disableAnimations: true));
        // Single pump without waiting for animation duration
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.text(r'$42'), findsOneWidget);
      },
    );

    testWidgets('T06-3: Light mode golden snapshot comparison', (tester) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildHarness(theme: AppTheme.lightTheme, disableAnimations: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GetMaterialApp),
        matchesGoldenFile('goldens/welcome_light.png'),
      );
    }, tags: ['golden']);

    testWidgets('T06-3: Dark mode golden snapshot comparison', (tester) async {
      tester.view.physicalSize = const Size(430 * 3, 932 * 3);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildHarness(theme: AppTheme.darkTheme, disableAnimations: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GetMaterialApp),
        matchesGoldenFile('goldens/welcome_dark.png'),
      );
    }, tags: ['golden']);

    testWidgets(
      'T06-3: Max text scale (2.0x Dynamic Type) golden snapshot comparison',
      (tester) async {
        tester.view.physicalSize = const Size(430 * 3, 932 * 3);
        tester.view.devicePixelRatio = 3.0;

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

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
          matchesGoldenFile('goldens/welcome_max_text_scale.png'),
        );
      },
      tags: ['golden'],
    );
  });
}
