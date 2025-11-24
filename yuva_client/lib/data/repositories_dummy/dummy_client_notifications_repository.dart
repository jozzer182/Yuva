import '../repositories/client_notifications_repository.dart';
import '../models/client_notification.dart';

class DummyClientNotificationsRepository implements ClientNotificationsRepository {
  final List<ClientNotification> _notifications = [
    ClientNotification(
      id: 'notif_client_1',
      type: ClientNotificationType.newProposal,
      title: 'Nueva propuesta recibida',
      body: 'Luisa Rincón envió una propuesta para "Limpieza profunda de apartamento"',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      jobPostId: 'job_open_apartment',
      proposalId: 'prop_luisa_job1',
    ),
    ClientNotification(
      id: 'notif_client_2',
      type: ClientNotificationType.newMessage,
      title: 'Nuevo mensaje del profesional',
      body: 'Luisa Rincón te envió un mensaje',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      conversationId: 'conv_client_job1',
    ),
    ClientNotification(
      id: 'notif_client_3',
      type: ClientNotificationType.proposalStatusChange,
      title: 'Propuesta preseleccionada',
      body: 'Has preseleccionado la propuesta de Luisa Rincón',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      jobPostId: 'job_open_apartment',
      proposalId: 'prop_luisa_job1',
    ),
    ClientNotification(
      id: 'notif_client_4',
      type: ClientNotificationType.jobStatusChange,
      title: 'Trabajo completado',
      body: 'El profesional marcó el trabajo "Reset mensual de oficina" como completado',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      activeJobId: 'active_job_office',
    ),
    ClientNotification(
      id: 'notif_client_5',
      type: ClientNotificationType.newProposal,
      title: 'Nueva propuesta recibida',
      body: 'Camila Ortega envió una propuesta para "Limpieza profunda de apartamento"',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      jobPostId: 'job_open_apartment',
      proposalId: 'prop_camila_job1',
    ),
    ClientNotification(
      id: 'notif_client_6',
      type: ClientNotificationType.genericInfo,
      title: 'Bienvenido a yuva',
      body: 'Ahora puedes gestionar tus trabajos y comunicarte con profesionales',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
  ];

  @override
  Future<List<ClientNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Ordenar por fecha más reciente primero
    final sorted = List<ClientNotification>.from(_notifications);
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

