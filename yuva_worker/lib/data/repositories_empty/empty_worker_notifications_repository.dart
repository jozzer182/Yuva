import '../models/worker_notification.dart';
import '../repositories/worker_notifications_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyWorkerNotificationsRepository implements WorkerNotificationsRepository {
  @override
  Future<List<WorkerNotification>> getNotifications() async {
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

