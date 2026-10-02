import 'dart:async';

/// Event payload emitted when a quick-add deep link is triggered.
class QuickAddTriggerEvent {
  /// Creates a [QuickAddTriggerEvent].
  const QuickAddTriggerEvent({required this.source, this.rawUri});

  /// The entrypoint source (e.g. 'widget', 'lockscreen', 'notification').
  final String source;

  /// The original incoming URI.
  final Uri? rawUri;
}

/// Contract for listening to system deep links and routing actions.
abstract class IDeepLinkService {
  /// Stream emitting events when a valid quick-add deep link is received.
  Stream<QuickAddTriggerEvent> get quickAddTriggerStream;

  /// Initializes deep link listeners.
  Future<void> init();

  /// The pending deep link waiting to be consumed (e.g. from cold start).
  Uri? get pendingDeepLink;

  /// Consumes and clears the pending deep link, returning it exactly once.
  Uri? consumePendingDeepLink();

  /// Sets or clears the pending deep link.
  void setPendingDeepLink(Uri? uri);

  /// Manually evaluates and dispatches an incoming deep link [uri].
  void handleUri(Uri uri);

  /// Disposes active stream subscriptions and controllers.
  Future<void> dispose();
}
