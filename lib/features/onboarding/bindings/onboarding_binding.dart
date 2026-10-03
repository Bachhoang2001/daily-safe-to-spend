import 'package:get/get.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/domain/repositories/i_settings_repository.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';

/// Dependency binding for the onboarding feature.
///
/// Ensures [OnboardingController] is shared across all onboarding steps
/// and disposed when leaving the onboarding wizard.
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<INavigator>()) {
      Get.lazyPut<INavigator>(() => const AppNavigator(), fenix: true);
    }

    if (!Get.isRegistered<OnboardingController>()) {
      Get.lazyPut<OnboardingController>(
        () => OnboardingController(
          analytics: Get.find<IAnalyticsService>(),
          navigator: Get.find<INavigator>(),
          settingsRepo: Get.find<ISettingsRepository>(),
          clock: Get.isRegistered<Clock>()
              ? Get.find<Clock>()
              : const SystemClock(),
        ),
      );
    }
  }
}
