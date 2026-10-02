import 'dart:async';

import 'package:get/get.dart';
import 'package:safe_to_spend/core/analytics/analytics_events.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/startup/startup_task.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/domain/repositories/i_category_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';
import 'package:safe_to_spend/domain/services/i_deep_link_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Controller managing application startup, database verification,
/// category seeding, and initial route dispatching.
class SplashController extends GetxController {
  /// Creates a [SplashController].
  SplashController({
    required this.profileRepo,
    required this.categoryRepo,
    required this.deepLinkService,
    required this.analytics,
    required this.clock,
    this.startupTaskRunner,
    this.navigateToRoute,
  });

  /// Repository providing user profile and onboarding completion state.
  final IProfileRepository profileRepo;

  /// Repository for ensuring default categories are seeded.
  final ICategoryRepository categoryRepo;

  /// Service managing cold start and active deep links.
  final IDeepLinkService deepLinkService;

  /// Analytics service for app open and error tracking.
  final IAnalyticsService analytics;

  /// System clock provider.
  final Clock clock;

  /// Optional lazy task runner for non-blocking third party SDKs.
  final IStartupTaskRunner? startupTaskRunner;

  /// Optional route navigation override (useful for testing or custom dispatch).
  final void Function(String route)? navigateToRoute;

  /// Current loading / error state of bootstrap.
  final Rx<ViewState> viewState = ViewState.idle.obs;

  /// Resolved initial route to navigate to after splash.
  final RxString destinationRoute = ''.obs;

  /// Holds error message details when bootstrap fails.
  final RxnString errorMessage = RxnString();

  /// Whether a quick-add action was requested via cold-start deep link.
  final RxBool shouldTriggerQuickAdd = false.obs;

  @override
  void onReady() {
    super.onReady();
    if (!Get.testMode) {
      unawaited(bootstrap());
    }
  }

  /// Executes sequential bootstrap steps.
  Future<void> bootstrap() async {
    viewState.value = ViewState.loading;
    errorMessage.value = null;

    try {
      // 1. Seed default categories (idempotent, safe to rerun)
      await categoryRepo.seedDefaultCategories();

      // 2. Check profile onboarding status
      final hasCompleted = await profileRepo.hasCompletedOnboarding();

      // 3. Log app_open analytics event
      await analytics.logEvent(
        AnalyticsEvents.appOpen,
        parameters: {
          AnalyticsEvents.isFirstOpen: !hasCompleted,
          AnalyticsEvents.hasProfile: hasCompleted,
        },
      );

      // 4. Trigger post-frame lazy tasks (RevenueCat, AdMob)
      unawaited(startupTaskRunner?.runPostFrameTasks());

      // 5. Consume cold-start pending deep link (consume-once pattern)
      final pendingUri = deepLinkService.consumePendingDeepLink();

      if (hasCompleted) {
        destinationRoute.value = AppRoutes.today;
        if (pendingUri != null) {
          shouldTriggerQuickAdd.value = true;
          deepLinkService.handleUri(pendingUri);
        }
      } else {
        destinationRoute.value = AppRoutes.onboardingWelcome;
        shouldTriggerQuickAdd.value = false;
      }

      viewState.value = ViewState.success;

      // 6. Navigate to destination route if not running in test mode
      if (destinationRoute.value.isNotEmpty && !Get.testMode) {
        if (navigateToRoute != null) {
          navigateToRoute!(destinationRoute.value);
        } else {
          unawaited(Get.offAllNamed<dynamic>(destinationRoute.value));
        }
      }
    } on Object catch (e, st) {
      viewState.value = ViewState.error;
      errorMessage.value = e.toString();
      await analytics.recordError(
        e,
        st,
        reason: 'Failed to bootstrap application',
      );
    }
  }

  /// Retries bootstrap following an error.
  Future<void> retryBootstrap() async {
    await bootstrap();
  }

  /// Launches support mailto client for troubleshooting.
  Future<void> contactSupport() async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'support@safetospend.app',
      queryParameters: {
        'subject': 'Daily Safe-to-Spend Startup Issue',
        'body': 'Error details:\n${errorMessage.value ?? "Unknown error"}',
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } on Object catch (e, st) {
      await analytics.recordError(
        e,
        st,
        reason: 'Failed to launch contact support mail client',
      );
    }
  }
}
