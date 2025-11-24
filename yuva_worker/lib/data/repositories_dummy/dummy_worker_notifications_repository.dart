import '../repositories/worker_notifications_repository.dart';
import '../models/worker_notification.dart';

class DummyWorkerNotificationsRepository implements WorkerNotificationsRepository {
  final List<WorkerNotification> _notifications = [
    WorkerNotification(
      id: 'notif1',
      type: WorkerNotificationType.proposalStatusChange,
      title: 'Tu propuesta fue preseleccionada',
      body: 'Tu propuesta para "Limpieza profunda de apartamento" ha sido preseleccionada por el cliente',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      jobPostId: 'job1',
    ),
    WorkerNotification(
      id: 'notif2',
      type: WorkerNotificationType.newMessage,
      title: 'Nuevo mensaje del cliente',
      body: 'María García te envió un mensaje',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      conversationId: 'conv1',
    ),
    WorkerNotification(
      id: 'notif3',
      type: WorkerNotificationType.proposalStatusChange,
      title: 'Tu propuesta fue rechazada',
      body: 'Tu propuesta para "Mantenimiento semanal casa" no fue seleccionada',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      jobPostId: 'job2',
    ),
    WorkerNotification(
      id: 'notif4',
      type: WorkerNotificationType.jobStatusChange,
      title: 'El trabajo fue marcado como completado',
      body: 'El cliente marcó el trabajo "Limpieza de oficina" como completado',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      activeJobId: 'activeJob1',
    ),
    WorkerNotification(
      id: 'notif5',
      type: WorkerNotificationType.proposalStatusChange,
      title: '¡Felicidades! Has sido contratado',
      body: 'Tu propuesta para "Limpieza post mudanza" fue aceptada',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      jobPostId: 'job3',
    ),
    WorkerNotification(
      id: 'notif6',
      type: WorkerNotificationType.genericInfo,
      title: 'Nueva función disponible',
      body: 'Ahora puedes ver tus ganancias en tiempo real desde la pantalla de inicio',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
  ];

  @override
  Future<List<WorkerNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Ordenar por fecha más reciente primero
    final sorted = List<WorkerNotification>.from(_notifications);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }
}

