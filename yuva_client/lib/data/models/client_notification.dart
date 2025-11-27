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

  /// Creates a ClientNotification from a Firestore document map.
  factory ClientNotification.fromMap(Map<String, dynamic> map, String docId) {
    return ClientNotification(
      id: docId,
      type: ClientNotificationType.values.firstWhere(
        (e) => e.name == (map['type'] as String? ?? 'genericInfo'),
        orElse: () => ClientNotificationType.genericInfo,
      ),
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      isRead: map['isRead'] as bool? ?? false,
      jobPostId: map['jobPostId'] as String?,
      proposalId: map['proposalId'] as String?,
      activeJobId: map['activeJobId'] as String?,
      conversationId: map['conversationId'] as String?,
    );
  }

  /// Converts this ClientNotification to a Firestore document map.
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'title': title,
      'body': body,
      'createdAt': createdAt,
      'isRead': isRead,
      if (jobPostId != null) 'jobPostId': jobPostId,
      if (proposalId != null) 'proposalId': proposalId,
      if (activeJobId != null) 'activeJobId': activeJobId,
      if (conversationId != null) 'conversationId': conversationId,
    };
  }
}

