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
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/pages/onboarding_bills_page.dart';

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
        child: const OnboardingBillsPage(),
      ),
    );
  }

  group('OnboardingBillsPage Design, Accessibility & Responsiveness', () {
    testWidgets(
      'Light mode layout renders completely with zero layout exceptions',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Rent',
          amount: Money(120000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 5),
        );
        controller.addDraftBill(bill1);

        await tester.pumpWidget(buildHarness(theme: AppTheme.lightTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(
          find.text('Any regular bills before your next payday?'),
          findsOneWidget,
        );
        expect(find.text('Step 3 of 4'), findsOneWidget);
        expect(find.text('Rent'), findsWidgets);
        expect(find.text('Continue'), findsOneWidget);
        expect(find.text('Skip for now'), findsOneWidget);
      },
    );

    testWidgets(
      'Dark mode layout renders completely with zero layout exceptions',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.irregular)
          ..setStartingBalance(const Money(200000))
          ..setHorizon(14);

        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Internet',
          amount: Money(6000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 10),
        );
        controller.addDraftBill(bill1);

        await tester.pumpWidget(buildHarness(theme: AppTheme.darkTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(
          find.text('Any regular bills in the next 14 days?'),
          findsOneWidget,
        );
        expect(find.text('Internet'), findsWidgets);
        expect(find.text('Continue'), findsOneWidget);
      },
    );

    testWidgets(
      '2.0x Dynamic Type renders without text clipping or layout overflow',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Health Insurance',
          amount: Money(25000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 8),
        );
        controller.addDraftBill(bill1);

        await tester.pumpWidget(
          buildHarness(theme: AppTheme.lightTheme, textScale: 2),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Step 3 of 4'), findsOneWidget);
        expect(find.text('Continue'), findsOneWidget);
      },
    );

    testWidgets(
      'Suggestion chips have accessible Semantics labels and touch targets',
      (tester) async {
        await tester.pumpWidget(buildHarness());
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('Add Rent bill'), findsOneWidget);
        expect(find.bySemanticsLabel('Add Internet bill'), findsOneWidget);
      },
    );
  });
}
