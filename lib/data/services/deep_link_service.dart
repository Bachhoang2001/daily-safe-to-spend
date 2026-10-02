import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';
import 'package:safe_to_spend/domain/services/i_deep_link_service.dart';

/// Implementation of [IDeepLinkService] utilizing [AppLinks] to intercept
/// incoming custom URI schemes (e.g. `safetospend://quick-add`).
class DeepLinkService extends GetxService implements IDeepLinkService {
  /// Creates a [DeepLinkService].
  DeepLinkService({
    required this.profileRepo,
    required this.analytics,
    this.incomingUriStream,
    AppLinks? appLinks,
  }) : _appLinks = appLinks ?? AppLinks();

  /// Repository for verifying onboarding completion before opening modal actions.
  final IProfileRepository profileRepo;

  /// Analytics service for logging deep link opens.
  final IAnalyticsService analytics;

  /// Optional custom incoming URI stream, primarily used for tests.
  final Stream<Uri>? incomingUriStream;
  final AppLinks _appLinks;

  final StreamController<QuickAddTriggerEvent> _quickAddController =
      StreamController<QuickAddTriggerEvent>.broadcast();

  StreamSubscription<Uri>? _uriSubscription;
  Uri? _pendingDeepLink;
  Uri? _lastHandledUri;
  DateTime? _lastHandledTime;

  @override
  Uri? get pendingDeepLink => _pendingDeepLink;

  @override
  Uri? consumePendingDeepLink() {
    final uri = _pendingDeepLink;
    _pendingDeepLink = null;
    return uri;
  }

  @override
  void setPendingDeepLink(Uri? uri) {
    _pendingDeepLink = uri;
  }

  bool _isDuplicate(Uri uri) {
    final now = DateTime.now();
    if (_lastHandledUri == uri &&
        _lastHandledTime != null &&
        now.difference(_lastHandledTime!).inMilliseconds < 1500) {
      return true;
    }
    _lastHandledUri = uri;
    _lastHandledTime = now;
    return false;
  }

  bool _initialized = false;

  @override
  void onInit() {
    super.onInit();
    unawaited(init());
  }

  @override
  Stream<QuickAddTriggerEvent> get quickAddTriggerStream =>
      _quickAddController.stream;

  @override
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    if (incomingUriStream != null) {
      _uriSubscription = incomingUriStream!.listen(handleUri);
      return;
    }

    // 1. Process cold start initial link if launched from deep link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _pendingDeepLink = initialUri;
        handleUri(initialUri);
      }
    } on Object catch (e, st) {
      await analytics.recordError(
        e,
        st,
        reason: 'Failed to retrieve initial deep link on cold start',
      );
    }

    // 2. Listen to subsequent incoming deep links while app is running
    _uriSubscription = _appLinks.uriLinkStream.listen(handleUri);
  }

  @override
  void handleUri(Uri uri) {
    if (uri.scheme != 'safetospend' || uri.host != 'quick-add') {
      return;
    }

    if (_isDuplicate(uri)) {
      return;
    }

    _processQuickAdd(uri);
  }

  Future<void> _processQuickAdd(Uri uri) async {
    try {
      final completed = await profileRepo.hasCompletedOnboarding();
      if (!completed) {
        return;
      }

      final source = uri.queryParameters['source'] ?? 'deep_link';
      await analytics.logEvent(
        'deep_link_quick_add',
        parameters: {'source': source},
      );

      if (!_quickAddController.isClosed) {
        _quickAddController.add(
          QuickAddTriggerEvent(source: source, rawUri: uri),
        );
      }
    } on Object catch (e, st) {
      await analytics.recordError(
        e,
        st,
        reason: 'Failed to process quick-add deep link',
      );
    }
  }

  @override
  void onClose() {
    unawaited(_uriSubscription?.cancel());
    unawaited(_quickAddController.close());
    super.onClose();
  }

  @override
  Future<void> dispose() async {
    await _uriSubscription?.cancel();
    await _quickAddController.close();
  }
}
