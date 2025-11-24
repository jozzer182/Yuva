import 'package:equatable/equatable.dart';

/// Tipo de notificación
/// Alineado conceptualmente con WorkerNotificationType en yuva_worker
enum ClientNotificationType {
  newProposal,
  proposalStatusChange,
  newMessage,
  jobStatusChange,
  genericInfo,
}

/// Notificación para el cliente
/// Alineado con WorkerNotification en yuva_worker
class ClientNotification extends Equatable {
  final String id;
  final ClientNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? jobPostId;
  final String? proposalId;
  final String? activeJobId;
  final String? conversationId;

  const ClientNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.jobPostId,
    this.proposalId,
    this.activeJobId,
    this.conversationId,
  });

  ClientNotification copyWith({
    String? id,
    ClientNotificationType? type,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? jobPostId,
    String? proposalId,
    String? activeJobId,
    String? conversationId,
  }) {
    return ClientNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      jobPostId: jobPostId ?? this.jobPostId,
      proposalId: proposalId ?? this.proposalId,
      activeJobId: activeJobId ?? this.activeJobId,
      conversationId: conversationId ?? this.conversationId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        body,
        createdAt,
        isRead,
        jobPostId,
        proposalId,
        activeJobId,
        conversationId,
      ];
}

