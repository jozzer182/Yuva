import '../models/client_notification.dart';

abstract class ClientNotificationsRepository {
  Future<List<ClientNotification>> getNotifications();
  Future<void> markNotificationRead(String notificationId);
  Future<void> markAllRead();
}

