import 'package:equatable/equatable.dart';

/// Tipo de notificación
enum WorkerNotificationType {
  proposalStatusChange,
  newMessage,
  jobStatusChange,
  genericInfo,
}

/// Notificación para el trabajador
class WorkerNotification extends Equatable {
  final String id;
  final WorkerNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? jobPostId;
  final String? activeJobId;
  final String? conversationId;

  const WorkerNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.jobPostId,
    this.activeJobId,
    this.conversationId,
  });

  WorkerNotification copyWith({
    String? id,
    WorkerNotificationType? type,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? jobPostId,
    String? activeJobId,
    String? conversationId,
  }) {
    return WorkerNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      jobPostId: jobPostId ?? this.jobPostId,
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
        activeJobId,
        conversationId,
      ];
}

