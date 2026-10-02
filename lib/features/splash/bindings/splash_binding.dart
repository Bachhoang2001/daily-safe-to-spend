import 'package:get/get.dart';
import 'package:safe_to_spend/core/startup/startup_task.dart';
import 'package:safe_to_spend/features/splash/controllers/splash_controller.dart';

/// Dependency injection binding for the splash / bootstrap feature.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        profileRepo: Get.find(),
        categoryRepo: Get.find(),
        deepLinkService: Get.find(),
        analytics: Get.find(),
        clock: Get.find(),
        startupTaskRunner: Get.isRegistered<IStartupTaskRunner>()
            ? Get.find<IStartupTaskRunner>()
            : null,
      ),
    );
  }
}
