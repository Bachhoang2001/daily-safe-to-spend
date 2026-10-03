import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/core/theme/app_theme.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';
import 'package:safe_to_spend/features/onboarding/pages/onboarding_result_page.dart';

import '../../../helpers/fake_clock.dart';
import '../../../helpers/mock_services.dart';

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

  const standardSnapshot = BudgetSnapshot(
    safeToday: Money(4200),
    tomorrowForecast: Money(4200),
    status: BudgetStatus.good,
    remainingInPeriod: Money(42000),
    daysLeftInPeriod: 10,
    dailyBaseline: Money(4200),
  );

  const deficitSnapshot = BudgetSnapshot(
    safeToday: Money.usd(0),
    tomorrowForecast: Money.usd(0),
    status: BudgetStatus.over,
    remainingInPeriod: Money.usd(-5000),
    daysLeftInPeriod: 10,
    dailyBaseline: Money.usd(0),
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
      () => mockAnalytics.logEvent(any(), parameters: any(named: 'parameters')),
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

    when(() => mockSnapshotService.preview(any())).thenReturn(standardSnapshot);

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
          size: const Size(430, 932),
          disableAnimations: disableAnimations,
        ),
        child: const OnboardingResultPage(),
      ),
    );
  }

  group('OnboardingResultPage', () {
    testWidgets(
      'T09-1: renders safe today calculated amount and subtitle until next payday',
      (tester) async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 15))
          ..computePreview();

        await tester.pumpWidget(buildHarness());
        await tester.pump(const Duration(milliseconds: 900));

        expect(find.textContaining(r'$42'), findsWidgets);
        expect(find.textContaining('payday'), findsOneWidget);
      },
    );

    testWidgets(
      'T09-2: tapping Go to Today invokes controller.completeOnboarding',
      (tester) async {
        controller.computePreview();

        await tester.pumpWidget(buildHarness());
        await tester.pump(const Duration(milliseconds: 900));

        final button = find.widgetWithText(ElevatedButton, 'Go to Today');
        expect(button, findsOneWidget);

        await tester.tap(button);
        await tester.pumpAndSettle();

        verify(
          () => mockProfileRepo.saveOnboarding(
            profile: any(named: 'profile'),
            bills: any(named: 'bills'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'T09-3: displays error message and allows retry when state is ViewState.error',
      (tester) async {
        controller.computePreview();
        controller.state.value = ViewState.error;
        controller.errorMessage.value = 'Failed to save profile';

        await tester.pumpWidget(buildHarness());
        await tester.pump();

        expect(find.text('Failed to save profile'), findsOneWidget);
        expect(find.text('Try again'), findsOneWidget);

        await tester.tap(find.text('Try again'));
        await tester.pumpAndSettle();

        verify(
          () => mockProfileRepo.saveOnboarding(
            profile: any(named: 'profile'),
            bills: any(named: 'bills'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'T09-4: tapping Not now on notification prompt dismisses prompt without requesting permission',
      (tester) async {
        controller.computePreview();

        await tester.pumpWidget(buildHarness());
        await tester.pump(const Duration(milliseconds: 900));

        final notNowButton = find.text('Not now');
        expect(notNowButton, findsOneWidget);

        await tester.tap(notNowButton);
        await tester.pumpAndSettle();

        verifyNever(() => mockNotificationService.requestPermission());
        expect(controller.notificationPromptHandled.value, isTrue);
      },
    );

    testWidgets(
      'T09-4: tapping Turn on requests system notification permission',
      (tester) async {
        controller.computePreview();

        await tester.pumpWidget(buildHarness());
        await tester.pump(const Duration(milliseconds: 900));

        final turnOnButton = find.text('Turn on');
        expect(turnOnButton, findsOneWidget);

        await tester.tap(turnOnButton);
        await tester.pumpAndSettle();

        verify(() => mockNotificationService.requestPermission()).called(1);
        expect(controller.notificationPromptHandled.value, isTrue);
      },
    );

    testWidgets(
      'T09-5: displays gentle deficit message when status is BudgetStatus.over',
      (tester) async {
        when(
          () => mockSnapshotService.preview(any()),
        ).thenReturn(deficitSnapshot);
        controller.computePreview();

        await tester.pumpWidget(buildHarness());
        await tester.pump(const Duration(milliseconds: 900));

        expect(
          find.textContaining(
            'Your bills are more than your money until payday',
          ),
          findsOneWidget,
        );
        expect(find.text('Go to Today'), findsOneWidget);
      },
    );

    testWidgets(
      'T09-ReducedMotion: renders final amount immediately when disableAnimations is true',
      (tester) async {
        controller.computePreview();

        await tester.pumpWidget(buildHarness(disableAnimations: true));
        // Check on the very first frame without pumping duration
        await tester.pump();

        expect(find.textContaining(r'$42'), findsWidgets);
      },
    );

    testWidgets('T09-Progress: renders step 4 of 4 progress', (tester) async {
      controller.computePreview();

      await tester.pumpWidget(buildHarness());
      await tester.pump(const Duration(milliseconds: 900));

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
