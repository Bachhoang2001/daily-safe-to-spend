import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/analytics/analytics_events.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/pages/income_setup_page.dart';

import '../../../helpers/fake_clock.dart';
import '../../../helpers/mock_services.dart';

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
      () => mockAnalytics.logEvent(any(), parameters: any(named: 'parameters')),
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
        child: const IncomeSetupPage(),
      ),
    );
  }

  group('IncomeSetupPage (T07-1, T07-3, T07-4, T07-6, DoD)', () {
    testWidgets(
      'T07-1: renders question blocks for mode selection and fixed income, with Continue button initially disabled',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // Header / question text
        expect(find.textContaining('How do you get paid?'), findsOneWidget);
        expect(
          find.textContaining('Same amount on a schedule'),
          findsOneWidget,
        );
        expect(find.textContaining('My income varies'), findsOneWidget);

        // Fixed income questions visible by default
        expect(
          find.textContaining('When is your next payday?'),
          findsOneWidget,
        );
        expect(
          find.textContaining('How much do you take home'),
          findsOneWidget,
        );

        // Continue button disabled initially because amounts and dates are missing
        final continueBtn = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Continue'),
        );
        expect(continueBtn.onPressed, isNull);
      },
    );

    testWidgets(
      'T07-1: entering complete and valid fixed income info enables Continue button and advances to bills',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // Populate valid fixed income state in controller
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15))
          ..setIncomePerPaycheck(const Money(250000))
          ..setFirstPeriodBalance(const Money(120000));

        await tester.pumpAndSettle();

        final continueBtn = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Continue'),
        );
        expect(continueBtn.onPressed, isNotNull);

        // Tap continue
        await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
        await tester.pumpAndSettle();

        verify(
          () => mockAnalytics.logEvent(
            AnalyticsEvents.onboardingStepCompleted,
            parameters: {'step': 'income'},
          ),
        ).called(1);
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingBills),
        ).called(1);
      },
    );

    testWidgets(
      'T07-3: selecting Irregular income mode displays starting balance field and horizon selector defaulting to 14 days',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // Tap irregular income mode card
        final irregularCard = find.textContaining('My income varies');
        expect(irregularCard, findsOneWidget);
        await tester.tap(irregularCard);
        await tester.pumpAndSettle();

        expect(controller.draft.value.incomeMode, equals(IncomeMode.irregular));
        expect(controller.draft.value.safetyHorizonDays, equals(14));
        expect(controller.draft.value.bufferPercent, equals(10));

        // Displays irregular questions
        expect(
          find.textContaining('How much money do you have right now?'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Plan ahead for how many days?'),
          findsOneWidget,
        );
        expect(find.textContaining('14'), findsWidgets);
      },
    );

    testWidgets(
      'T07-3: Irregular mode Continue button toggles based on starting balance validation',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        controller.selectIncomeMode(IncomeMode.irregular);
        await tester.pumpAndSettle();

        // Initially disabled with 0 balance
        var continueBtn = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Continue'),
        );
        expect(continueBtn.onPressed, isNull);

        // Set valid positive starting balance
        controller.setStartingBalance(const Money(75000));
        await tester.pumpAndSettle();

        continueBtn = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Continue'),
        );
        expect(continueBtn.onPressed, isNotNull);
      },
    );

    testWidgets(
      'T07-4: switching modes updates visible input blocks dynamically',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // Switch to irregular
        await tester.tap(find.textContaining('My income varies'));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('Plan ahead for how many days?'),
          findsOneWidget,
        );
        expect(find.textContaining('When is your next payday?'), findsNothing);

        // Switch back to fixed
        await tester.tap(find.textContaining('Same amount on a schedule'));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('When is your next payday?'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Plan ahead for how many days?'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'T07-6: next payday date picker enforces future dates and respects frequency constraints',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        controller.selectFrequency(PayFrequency.weekly);
        await tester.pumpAndSettle();

        final range = controller.allowedPaydayRange;
        expect(range.start, equals(const LocalDate(2026, 1, 1)));
        expect(range.end, equals(const LocalDate(2026, 1, 8)));
      },
    );

    testWidgets('DoD: displays progress indicator at Step 2 of 4', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(find.textContaining('2 of 4'), findsOneWidget);
    });
  });
}
