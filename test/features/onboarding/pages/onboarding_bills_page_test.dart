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
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/pages/onboarding_bills_page.dart';

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
        child: const OnboardingBillsPage(),
      ),
    );
  }

  group('OnboardingBillsPage (T08-1, T08-2, T08-3, T08-4, DoD)', () {
    testWidgets(
      'T08-1: renders progress 3/4, title for fixed mode, suggestion chips, and action buttons',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // Step progress 3/4
        expect(find.textContaining('3 of 4'), findsOneWidget);

        // Title for fixed mode
        expect(
          find.textContaining('Any regular bills before your next payday?'),
          findsOneWidget,
        );

        // Suggestion chips
        expect(find.text('Rent'), findsOneWidget);
        expect(find.text('Phone'), findsOneWidget);
        expect(find.text('Internet'), findsOneWidget);
        expect(find.text('Utilities'), findsOneWidget);
        expect(find.text('Car payment'), findsOneWidget);
        expect(find.text('Insurance'), findsOneWidget);
        expect(find.text('Subscriptions'), findsOneWidget);
        expect(find.text('Custom'), findsOneWidget);

        // Buttons
        expect(find.text('Continue'), findsOneWidget);
        expect(find.text('Skip for now'), findsOneWidget);
      },
    );

    testWidgets(
      'T08-1: renders irregular title and updates total bills display when bills are added',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.irregular)
          ..setStartingBalance(const Money(150000))
          ..setHorizon(14);

        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Rent',
          amount: Money(100000), // $1,000
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 5),
        );
        const bill2 = OnboardingBillDraft(
          id: 'bill-2',
          name: 'Internet',
          amount: Money(6000), // $60
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 10),
        );

        controller
          ..addDraftBill(bill1)
          ..addDraftBill(bill2);

        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // Irregular title with 14 days
        expect(
          find.textContaining('Any regular bills in the next 14 days?'),
          findsOneWidget,
        );

        // Added bill names
        expect(find.text('Rent'), findsWidgets);
        expect(find.text('Internet'), findsWidgets);

        // Total bills line: $1,060
        expect(
          find.textContaining(r'Bills before payday: $1,060'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'T08-1 / T08-3 / DoD: tapping a suggestion chip opens bottom sheet with prefilled name',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        // Tap 'Rent' chip
        final rentChip = find.widgetWithText(ActionChip, 'Rent');
        expect(rentChip, findsOneWidget);
        await tester.tap(rentChip);
        await tester.pumpAndSettle();

        // Bottom sheet opens
        expect(find.text('Add Bill'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Rent'), findsOneWidget);
      },
    );

    testWidgets(
      'T08-2: tapping Skip for now calls skipBillsStep and navigates to result',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        final skipButton = find.text('Skip for now');
        expect(skipButton, findsOneWidget);

        await tester.tap(skipButton);
        await tester.pumpAndSettle();

        verify(
          () => mockAnalytics.logEvent(AnalyticsEvents.onboardingBillsSkipped),
        ).called(1);
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingResult),
        ).called(1);
        expect(controller.currentStep.value, equals(4));
      },
    );

    testWidgets(
      'T08-4: swiping a bill item card deletes the bill via Dismissible',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Rent',
          amount: Money(100000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 5),
        );
        controller.addDraftBill(bill1);

        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        expect(find.text('Rent'), findsWidgets);

        // Find dismissible and drag to dismiss
        final dismissibleFinder = find.byType(Dismissible);
        expect(dismissibleFinder, findsOneWidget);

        await tester.drag(dismissibleFinder, const Offset(-500, 0));
        await tester.pumpAndSettle();

        // Bill deleted from draft
        expect(controller.draft.value.bills, isEmpty);
        expect(controller.billsTotalBeforePayday, equals(const Money(0)));
      },
    );

    testWidgets(
      'T08-1 / DoD: tapping Continue button calls submitBillsStep and navigates to result',
      (tester) async {
        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Rent',
          amount: Money(100000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 5),
        );
        controller.addDraftBill(bill1);

        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        final continueButton = find.text('Continue');
        expect(continueButton, findsOneWidget);

        await tester.tap(continueButton);
        await tester.pumpAndSettle();

        verify(
          () => mockAnalytics.logEvent(
            AnalyticsEvents.onboardingBillsAdded,
            parameters: {'count': 1},
          ),
        ).called(1);
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingResult),
        ).called(1);
        expect(controller.currentStep.value, equals(4));
      },
    );
  });
}
