import 'package:equatable/equatable.dart';

/// Conversación entre trabajador y cliente
class WorkerConversation extends Equatable {
  final String id;
  final String relatedJobId;
  final String clientDisplayName;
  final String lastMessagePreview;
  final DateTime lastMessageAt;
  final int unreadCount;

  const WorkerConversation({
    required this.id,
    required this.relatedJobId,
    required this.clientDisplayName,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    this.unreadCount = 0,
  });

  WorkerConversation copyWith({
    String? id,
    String? relatedJobId,
    String? clientDisplayName,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return WorkerConversation(
      id: id ?? this.id,
      relatedJobId: relatedJobId ?? this.relatedJobId,
      clientDisplayName: clientDisplayName ?? this.clientDisplayName,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        relatedJobId,
        clientDisplayName,
        lastMessagePreview,
        lastMessageAt,
        unreadCount,
      ];
}

