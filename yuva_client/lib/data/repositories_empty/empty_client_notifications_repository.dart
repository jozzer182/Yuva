import '../models/client_notification.dart';
import '../repositories/client_notifications_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyClientNotificationsRepository implements ClientNotificationsRepository {
  @override
  Future<List<ClientNotification>> getNotifications() async {
    return [];
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    // No-op
  }

  @override
  Future<void> markAllRead() async {
    // No-op
  }
}

