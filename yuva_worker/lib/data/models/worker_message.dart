import 'package:equatable/equatable.dart';

/// Tipo de remitente del mensaje
enum MessageSenderType {
  client,
  worker,
  system,
}

/// Mensaje en una conversación
class WorkerMessage extends Equatable {
  final String id;
  final String conversationId;
  final MessageSenderType senderType;
  final String text;
  final DateTime createdAt;
  final bool isRead;

  const WorkerMessage({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.text,
    required this.createdAt,
    this.isRead = false,
  });

  WorkerMessage copyWith({
    String? id,
    String? conversationId,
    MessageSenderType? senderType,
    String? text,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return WorkerMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderType,
        text,
        createdAt,
        isRead,
      ];
}

