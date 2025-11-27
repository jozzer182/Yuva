import 'package:equatable/equatable.dart';

/// Conversación entre trabajador y cliente
class WorkerConversation extends Equatable {
  final String id;
  final String clientId;
  final String workerId;
  final String? jobPostId;
  final String? activeJobId;
  final String clientDisplayName;
  final String? clientAvatarId;
  final String lastMessagePreview;
  final DateTime lastMessageAt;
  final int unreadCount;

  const WorkerConversation({
    required this.id,
    required this.clientId,
    required this.workerId,
    this.jobPostId,
    this.activeJobId,
    required this.clientDisplayName,
    this.clientAvatarId,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    this.unreadCount = 0,
  });

  /// Obtiene el ID relacionado (jobPostId o activeJobId)
  String? get relatedJobId => jobPostId ?? activeJobId;

  WorkerConversation copyWith({
    String? id,
    String? clientId,
    String? workerId,
    String? jobPostId,
    String? activeJobId,
    String? clientDisplayName,
    String? clientAvatarId,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return WorkerConversation(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      workerId: workerId ?? this.workerId,
      jobPostId: jobPostId ?? this.jobPostId,
      activeJobId: activeJobId ?? this.activeJobId,
      clientDisplayName: clientDisplayName ?? this.clientDisplayName,
      clientAvatarId: clientAvatarId ?? this.clientAvatarId,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clientId,
        workerId,
        jobPostId,
        activeJobId,
        clientDisplayName,
        clientAvatarId,
        lastMessagePreview,
        lastMessageAt,
        unreadCount,
      ];

  /// Creates a WorkerConversation from a Firestore document map.
  factory WorkerConversation.fromMap(Map<String, dynamic> map, String docId) {
    return WorkerConversation(
      id: docId,
      clientId: map['clientId'] as String? ?? '',
      workerId: map['workerId'] as String? ?? '',
      jobPostId: map['jobPostId'] as String?,
      activeJobId: map['activeJobId'] as String?,
      clientDisplayName: map['clientDisplayName'] as String? ?? '',
      clientAvatarId: map['clientAvatarId'] as String?,
      lastMessagePreview: map['lastMessagePreview'] as String? ?? '',
      lastMessageAt: map['lastMessageAt'] != null
          ? (map['lastMessageAt'] as dynamic).toDate()
          : DateTime.now(),
      unreadCount: (map['workerUnreadCount'] as int?) ?? 0,
    );
  }

  /// Converts this WorkerConversation to a Firestore document map.
  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'workerId': workerId,
      'jobPostId': jobPostId,
      'activeJobId': activeJobId,
      'clientDisplayName': clientDisplayName,
      'clientAvatarId': clientAvatarId,
      'lastMessagePreview': lastMessagePreview,
      'lastMessageAt': lastMessageAt,
      'workerUnreadCount': unreadCount,
    };
  }
}

