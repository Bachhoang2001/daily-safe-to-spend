import 'package:get/get.dart';
import 'package:safe_to_spend/core/analytics/analytics_events.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/domain/repositories/i_settings_repository.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Central controller managing the multi-step onboarding wizard.
class OnboardingController extends GetxController {
  /// Creates an instance of [OnboardingController].
  OnboardingController({
    required this.analytics,
    required this.navigator,
    this.settingsRepo,
    this.urlLauncher,
  });

  /// Analytics service for tracking onboarding events.
  final IAnalyticsService analytics;

  /// Navigation abstraction.
  final INavigator navigator;

  /// Application settings repository.
  final ISettingsRepository? settingsRepo;

  /// Optional custom URL launcher callback for tests.
  final Future<bool> Function(Uri url)? urlLauncher;

  /// Current step in the 4-step onboarding flow (1..4).
  final currentStep = 1.obs;

  /// In-memory draft holding user-configured settings before database persistence.
  final draft = const OnboardingDraft().obs;

  /// View state representing the status of asynchronous operations.
  final state = ViewState.idle.obs;

  /// Error message if an error occurs.
  final errorMessage = RxnString();

  /// Starts the onboarding setup by advancing to the Income configuration step.
  void start() {
    analytics.logEvent(AnalyticsEvents.onboardingStart);
    currentStep.value = 2;
    navigator.toNamed<dynamic>(AppRoutes.onboardingIncome);
  }

  /// Opens the external Privacy Policy URL.
  Future<bool> openPrivacyPolicy() async {
    return _launchUrlString('https://safetospend.app/privacy');
  }

  /// Opens the external Terms of Service URL.
  Future<bool> openTermsOfService() async {
    return _launchUrlString('https://safetospend.app/terms');
  }

  Future<bool> _launchUrlString(String url) async {
    try {
      final uri = Uri.parse(url);
      if (urlLauncher != null) {
        return await urlLauncher!(uri);
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object catch (e, st) {
      state.value = ViewState.error;
      errorMessage.value = e.toString();
      await analytics.recordError(e, st);
      return false;
    }
  }
}
