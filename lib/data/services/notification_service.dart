import 'package:get/get.dart';
import 'package:safe_to_spend/domain/services/i_notification_service.dart';

/// Concrete implementation of [INotificationService] managing system notification permissions.
class NotificationService extends GetxService implements INotificationService {
  @override
  Future<bool> hasPermission() async {
    // In MVP onboarding, default to false before requested.
    // Spec 018 integrates flutter_local_notifications plugin and channels.
    return false;
  }

  @override
  Future<bool> requestPermission() async {
    // For Spec 010 (permission flow), simulates or handles permission request.
    // Spec 018 completes the platform-specific notification scheduling.
    return true;
  }
}
