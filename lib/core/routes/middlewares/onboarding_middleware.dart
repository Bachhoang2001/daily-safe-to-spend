import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';

/// Middleware ensuring un-onboarded users are directed to the onboarding flow
/// when attempting to access the main application shell or protected sub-routes.
class OnboardingMiddleware extends GetMiddleware {
  /// Creates an [OnboardingMiddleware] instance.
  OnboardingMiddleware({this.profileRepo, this.hasCompletedOnboardingOverride});

  /// Optional repository providing access to user profile and onboarding state.
  /// If null, resolved lazily at redirect time via `Get.find`.
  final IProfileRepository? profileRepo;

  /// Optional override callback primarily used for unit testing.
  final bool Function()? hasCompletedOnboardingOverride;

  @override
  RouteSettings? redirect(String? route) {
    // 1. Bypass check for splash and all onboarding sub-screens
    if (route == null ||
        route == AppRoutes.splash ||
        route.startsWith('/onboarding/')) {
      return null;
    }

    // 2. Check override callback if supplied
    if (hasCompletedOnboardingOverride != null) {
      if (!hasCompletedOnboardingOverride!()) {
        return const RouteSettings(name: AppRoutes.onboardingWelcome);
      }
      return null;
    }

    // 3. Resolve repository instance lazily at navigation time
    final repo =
        profileRepo ??
        (Get.isRegistered<IProfileRepository>()
            ? Get.find<IProfileRepository>()
            : null);

    if (repo == null) {
      return const RouteSettings(name: AppRoutes.onboardingWelcome);
    }

    // 4. Check onboarding completion status
    if (!repo.hasCompletedOnboardingSync()) {
      return const RouteSettings(name: AppRoutes.onboardingWelcome);
    }

    // 5. Otherwise allow navigation to requested route
    return null;
  }
}
