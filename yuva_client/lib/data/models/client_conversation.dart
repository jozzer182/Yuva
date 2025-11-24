import 'package:equatable/equatable.dart';

/// Conversación entre cliente y trabajador
/// Alineado con WorkerConversation en yuva_worker
class ClientConversation extends Equatable {
  final String id;
  final String? jobPostId; // Puede ser null si es para un trabajo activo
  final String? activeJobId; // Puede ser null si es para un job post
  final String workerDisplayName;
  final String lastMessagePreview;
  final DateTime lastMessageAt;
  final int unreadCount;

  const ClientConversation({
    required this.id,
    this.jobPostId,
    this.activeJobId,
    required this.workerDisplayName,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    this.unreadCount = 0,
  }) : assert(
          jobPostId != null || activeJobId != null,
          'Either jobPostId or activeJobId must be provided',
        );

  /// Obtiene el ID relacionado (jobPostId o activeJobId)
  String get relatedJobId => jobPostId ?? activeJobId!;

  ClientConversation copyWith({
    String? id,
    String? jobPostId,
    String? activeJobId,
    String? workerDisplayName,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return ClientConversation(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      activeJobId: activeJobId ?? this.activeJobId,
      workerDisplayName: workerDisplayName ?? this.workerDisplayName,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jobPostId,
        activeJobId,
        workerDisplayName,
        lastMessagePreview,
        lastMessageAt,
        unreadCount,
      ];
}

