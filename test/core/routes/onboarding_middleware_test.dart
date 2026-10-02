import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/routes/middlewares/onboarding_middleware.dart';

import '../../helpers/mock_services.dart';

void main() {
  late MockProfileRepository mockProfileRepo;

  setUp(() {
    mockProfileRepo = MockProfileRepository();
  });

  group('OnboardingMiddleware (T04-1)', () {
    test(
      'T04-1: redirect returns null for splash route even if onboarding is incomplete',
      () {
        final middleware = OnboardingMiddleware(
          profileRepo: mockProfileRepo,
          hasCompletedOnboardingOverride: () => false,
        );

        final result = middleware.redirect(AppRoutes.splash);
        expect(result, isNull);
      },
    );

    test(
      'T04-1: redirect returns null for all /onboarding/* routes when onboarding is incomplete',
      () {
        final middleware = OnboardingMiddleware(
          profileRepo: mockProfileRepo,
          hasCompletedOnboardingOverride: () => false,
        );

        expect(middleware.redirect(AppRoutes.onboardingWelcome), isNull);
        expect(middleware.redirect(AppRoutes.onboardingIncome), isNull);
        expect(middleware.redirect(AppRoutes.onboardingBills), isNull);
        expect(middleware.redirect(AppRoutes.onboardingResult), isNull);
      },
    );

    test(
      'T04-1: redirect returns RouteSettings for /onboarding/welcome when accessing root without onboarding',
      () {
        final middleware = OnboardingMiddleware(
          profileRepo: mockProfileRepo,
          hasCompletedOnboardingOverride: () => false,
        );

        final result = middleware.redirect(AppRoutes.root);
        expect(result, isNotNull);
        expect(result?.name, AppRoutes.onboardingWelcome);
      },
    );

    test(
      'T04-1: redirect returns RouteSettings for /onboarding/welcome when accessing protected routes without onboarding',
      () {
        final middleware = OnboardingMiddleware(
          profileRepo: mockProfileRepo,
          hasCompletedOnboardingOverride: () => false,
        );

        final settingsResult = middleware.redirect(AppRoutes.settings);
        expect(settingsResult?.name, AppRoutes.onboardingWelcome);

        final expenseResult = middleware.redirect(AppRoutes.expenseEdit);
        expect(expenseResult?.name, AppRoutes.onboardingWelcome);
      },
    );

    test(
      'T04-1: redirect returns null for root and protected routes when onboarding is completed',
      () {
        final middleware = OnboardingMiddleware(
          profileRepo: mockProfileRepo,
          hasCompletedOnboardingOverride: () => true,
        );

        expect(middleware.redirect(AppRoutes.root), isNull);
        expect(middleware.redirect(AppRoutes.settings), isNull);
        expect(middleware.redirect(AppRoutes.expenseEdit), isNull);
      },
    );

    test('T04-1: redirect returns null when route string is null', () {
      final middleware = OnboardingMiddleware(
        profileRepo: mockProfileRepo,
        hasCompletedOnboardingOverride: () => false,
      );

      expect(middleware.redirect(null), isNull);
    });
  });
}
