/// Domain contract for querying and requesting notification permissions.
///
/// Implementations handle platform-specific permission dialogs (iOS / Android 13+).
/// Notification scheduling logic is implemented in Spec 018.
abstract class INotificationService {
  /// Checks whether notification permissions are currently granted by the system.
  Future<bool> hasPermission();

  /// Requests notification permissions via the system dialog.
  ///
  /// Returns `true` if granted by the user, `false` otherwise.
  Future<bool> requestPermission();
}
