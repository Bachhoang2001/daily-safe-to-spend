/// Standard analytics event names and parameter keys.
///
/// Ensures consistent event logging across the application without hardcoded strings.
/// Never log sensitive financial amounts or personal identifiable information (PII).
abstract class AnalyticsEvents {
  AnalyticsEvents._();

  /// Event emitted when the app finishes bootstrap and determines entry route.
  static const String appOpen = 'app_open';

  /// Event emitted when a quick-add deep link is triggered.
  static const String deepLinkQuickAdd = 'deep_link_quick_add';

  /// Event emitted when the user begins the onboarding wizard.
  static const String onboardingStart = 'onboarding_start';

  /// Event emitted when the user finishes onboarding setup.
  static const String onboardingComplete = 'onboarding_complete';

  // Parameter keys
  /// Whether this is the first time the app is launched.
  static const String isFirstOpen = 'is_first_open';

  /// Whether the user has completed onboarding / has an existing profile.
  static const String hasProfile = 'has_profile';

  /// The source trigger of an event (e.g. 'widget', 'lockscreen', 'notification').
  static const String source = 'source';
}
