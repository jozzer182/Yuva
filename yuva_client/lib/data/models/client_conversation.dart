import 'package:equatable/equatable.dart';

/// Conversación entre cliente y trabajador
/// Alineado con WorkerConversation en yuva_worker
class ClientConversation extends Equatable {
  final String id;
  final String clientId;
  final String workerId;
  final String? jobPostId; // Puede ser null si es para un trabajo activo
  final String? activeJobId; // Puede ser null si es para un job post
  final String workerDisplayName;
  final String? workerAvatarId;
  final String lastMessagePreview;
  final DateTime lastMessageAt;
  final int unreadCount;

  const ClientConversation({
    required this.id,
    required this.clientId,
    required this.workerId,
    this.jobPostId,
    this.activeJobId,
    required this.workerDisplayName,
    this.workerAvatarId,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    this.unreadCount = 0,
  });

  /// Obtiene el ID relacionado (jobPostId o activeJobId)
  String? get relatedJobId => jobPostId ?? activeJobId;

  ClientConversation copyWith({
    String? id,
    String? clientId,
    String? workerId,
    String? jobPostId,
    String? activeJobId,
    String? workerDisplayName,
    String? workerAvatarId,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return ClientConversation(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      workerId: workerId ?? this.workerId,
      jobPostId: jobPostId ?? this.jobPostId,
      activeJobId: activeJobId ?? this.activeJobId,
      workerDisplayName: workerDisplayName ?? this.workerDisplayName,
      workerAvatarId: workerAvatarId ?? this.workerAvatarId,
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
        workerDisplayName,
        workerAvatarId,
        lastMessagePreview,
        lastMessageAt,
        unreadCount,
      ];

  /// Creates a ClientConversation from a Firestore document map.
  factory ClientConversation.fromMap(Map<String, dynamic> map, String docId) {
    return ClientConversation(
      id: docId,
      clientId: map['clientId'] as String? ?? '',
      workerId: map['workerId'] as String? ?? '',
      jobPostId: map['jobPostId'] as String?,
      activeJobId: map['activeJobId'] as String?,
      workerDisplayName: map['workerDisplayName'] as String? ?? '',
      workerAvatarId: map['workerAvatarId'] as String?,
      lastMessagePreview: map['lastMessagePreview'] as String? ?? '',
      lastMessageAt: map['lastMessageAt'] != null
          ? (map['lastMessageAt'] as dynamic).toDate()
          : DateTime.now(),
      unreadCount: (map['clientUnreadCount'] as int?) ?? 0,
    );
  }

  /// Converts this ClientConversation to a Firestore document map.
  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'workerId': workerId,
      'jobPostId': jobPostId,
      'activeJobId': activeJobId,
      'workerDisplayName': workerDisplayName,
      'workerAvatarId': workerAvatarId,
      'lastMessagePreview': lastMessagePreview,
      'lastMessageAt': lastMessageAt,
      'clientUnreadCount': unreadCount,
    };
  }
}

