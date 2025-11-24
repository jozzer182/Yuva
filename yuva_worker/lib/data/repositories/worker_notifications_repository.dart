import '../models/worker_notification.dart';

abstract class WorkerNotificationsRepository {
  Future<List<WorkerNotification>> getNotifications();
  Future<void> markNotificationRead(String notificationId);
  Future<void> markAllRead();
}

