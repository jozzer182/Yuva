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

  /// Creates a WorkerNotification from a Firestore document map.
  factory WorkerNotification.fromMap(Map<String, dynamic> map, String docId) {
    return WorkerNotification(
      id: docId,
      type: WorkerNotificationType.values.firstWhere(
        (e) => e.name == (map['type'] as String? ?? 'genericInfo'),
        orElse: () => WorkerNotificationType.genericInfo,
      ),
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      isRead: map['isRead'] as bool? ?? false,
      jobPostId: map['jobPostId'] as String?,
      activeJobId: map['activeJobId'] as String?,
      conversationId: map['conversationId'] as String?,
    );
  }

  /// Converts this WorkerNotification to a Firestore document map.
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'title': title,
      'body': body,
      'createdAt': createdAt,
      'isRead': isRead,
      if (jobPostId != null) 'jobPostId': jobPostId,
      if (activeJobId != null) 'activeJobId': activeJobId,
      if (conversationId != null) 'conversationId': conversationId,
    };
  }
}

