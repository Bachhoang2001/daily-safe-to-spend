import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/analytics/analytics_events.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';

import '../../../helpers/mock_services.dart';

class MockNavigator extends Mock implements INavigator {}

void main() {
  late MockAnalyticsService mockAnalytics;
  late MockNavigator mockNavigator;
  late MockSettingsRepository mockSettings;
  late OnboardingController controller;

  setUp(() {
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
  });

  group('OnboardingController - Welcome (T06-1, T06-2)', () {
    test(
      'T06-1: initial state has currentStep 1, idle state, and default draft',
      () {
        expect(controller.currentStep.value, equals(1));
        expect(controller.state.value, equals(ViewState.idle));
        expect(controller.errorMessage.value, isNull);
        expect(controller.draft.value.currency, equals('USD'));
        expect(controller.draft.value.bufferPercent, equals(5));
      },
    );

    test(
      'T06-1: start() records onboarding_start event and navigates to onboarding income',
      () async {
        controller.start();

        verify(
          () => mockAnalytics.logEvent(AnalyticsEvents.onboardingStart),
        ).called(1);
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingIncome),
        ).called(1);
        expect(controller.currentStep.value, equals(2));
      },
    );

    test(
      'T06-2: openPrivacyPolicy() and openTermsOfService() open external legal URLs successfully',
      () async {
        final privacyResult = await controller.openPrivacyPolicy();
        final termsResult = await controller.openTermsOfService();

        expect(privacyResult, isTrue);
        expect(termsResult, isTrue);
        expect(controller.state.value, equals(ViewState.idle));
      },
    );

    test(
      'T06-2: failed URL launch transitions to ViewState.error and records error without throwing',
      () async {
        final failingController = OnboardingController(
          analytics: mockAnalytics,
          navigator: mockNavigator,
          settingsRepo: mockSettings,
          urlLauncher: (uri) async => throw Exception('Unable to open URL'),
        );

        final result = await failingController.openPrivacyPolicy();

        expect(result, isFalse);
        expect(failingController.state.value, equals(ViewState.error));
        expect(
          failingController.errorMessage.value,
          contains('Unable to open URL'),
        );
        verify(
          () => mockAnalytics.recordError(
            any(),
            any(),
            reason: any(named: 'reason'),
          ),
        ).called(1);
      },
    );
  });
}
