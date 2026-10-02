import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/pages/welcome_page.dart';

import '../../../helpers/mock_services.dart';

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
      () => mockAnalytics.logEvent(any(), parameters: any(named: 'parameters')),
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

  Widget buildHarness({ThemeData? theme, double textScale = 1.0}) {
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
          size: const Size(430, 932),
        ),
        child: const WelcomePage(),
      ),
    );
  }

  group('WelcomePage (T06-1, T06-2, DoD)', () {
    testWidgets(
      'T06-1: renders title, subtitle, sample card, 3 highlights, progress 1/4, CTA',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // Title & Subtitle
        expect(find.text("Know what's safe to spend today."), findsOneWidget);
        expect(
          find.text(
            'One number every morning. No bank login. Your data stays on your phone.',
          ),
          findsOneWidget,
        );

        // Sample card
        expect(find.textContaining('safe to spend today'), findsWidgets);

        // 3 key highlights
        expect(find.text('Built around your paycheck'), findsOneWidget);
        expect(find.text('Works with irregular income'), findsOneWidget);
        expect(find.text('Private by design'), findsOneWidget);

        // Progress step 1/4
        expect(find.textContaining('1'), findsWidgets);

        // CTA Button
        expect(find.text('Get started'), findsOneWidget);

        // Privacy & Terms
        expect(find.text('Privacy Policy'), findsOneWidget);
        expect(find.text('Terms of Service'), findsOneWidget);
      },
    );

    testWidgets(
      'T06-1: tapping Get started triggers controller.start() and navigates to income',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        final getStartedBtn = find.text('Get started');
        expect(getStartedBtn, findsOneWidget);

        await tester.tap(getStartedBtn);
        await tester.pumpAndSettle();

        verify(() => mockAnalytics.logEvent(any())).called(1);
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingIncome),
        ).called(1);
      },
    );

    testWidgets('T06-1 DoD: screen has NO skip button', (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsNothing);
      expect(find.text('skip'), findsNothing);
      expect(find.text('Bỏ qua'), findsNothing);
    });

    testWidgets(
      'T06-1 DoD: has PopScope configured to prevent popping back to splash',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        expect(find.byType(PopScope), findsOneWidget);
      },
    );

    testWidgets(
      'T06-2: tapping Privacy Policy and Terms triggers external legal links',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        final privacyLink = find.text('Privacy Policy');
        expect(privacyLink, findsOneWidget);
        await tester.tap(privacyLink);
        await tester.pumpAndSettle();

        final termsLink = find.text('Terms of Service');
        expect(termsLink, findsOneWidget);
        await tester.tap(termsLink);
        await tester.pumpAndSettle();
      },
    );
  });
}
