import 'package:flutter/widgets.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';

/// Contract for asynchronous background tasks initialized lazily after the first frame.
///
/// Ensures SDKs like RevenueCat (Spec 022) and Google Mobile Ads (Spec 026)
/// never block the main startup thread or breach the cold-start limit (<= 1.0s).
abstract class IStartupTask {
  /// Unique name identifying this startup task.
  String get name;

  /// Executes the startup task asynchronously.
  Future<void> execute();
}

/// Runner managing and executing registered [IStartupTask] instances.
abstract class IStartupTaskRunner {
  /// Registers a new [task] to be run lazily post-frame.
  void registerTask(IStartupTask task);

  /// Executes all registered tasks sequentially or concurrently, isolating errors.
  Future<void> runPostFrameTasks();
}

/// Default implementation of [IStartupTaskRunner].
///
/// Binds execution to [WidgetsBinding.addPostFrameCallback]
/// and logs errors without crashing the UI.

class StartupTaskRunner implements IStartupTaskRunner {
  /// Creates a [StartupTaskRunner].
  StartupTaskRunner({required this.analytics, List<IStartupTask>? initialTasks})
    : _tasks = [...?initialTasks];

  /// Analytics service for recording task failures.
  final IAnalyticsService analytics;

  final List<IStartupTask> _tasks;
  bool _executed = false;

  @override
  void registerTask(IStartupTask task) {
    _tasks.add(task);
  }

  @override
  Future<void> runPostFrameTasks() async {
    if (_executed) return;
    _executed = true;

    for (final task in _tasks) {
      try {
        await task.execute();
      } on Object catch (e, st) {
        await analytics.recordError(
          e,
          st,
          reason: 'Failed to execute lazy startup task: ${task.name}',
        );
      }
    }
  }

  /// Automatically schedules task execution after the first frame is rendered.
  void schedulePostFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runPostFrameTasks();
    });
  }
}
