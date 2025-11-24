import 'package:equatable/equatable.dart';

/// Tipo de remitente del mensaje
/// Alineado con MessageSenderType en yuva_worker
enum MessageSenderType {
  client,
  worker,
  system,
}

/// Mensaje en una conversación
/// Alineado con WorkerMessage en yuva_worker
class ClientMessage extends Equatable {
  final String id;
  final String conversationId;
  final MessageSenderType senderType;
  final String text;
  final DateTime createdAt;
  final bool isRead;

  const ClientMessage({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.text,
    required this.createdAt,
    this.isRead = false,
  });

  ClientMessage copyWith({
    String? id,
    String? conversationId,
    MessageSenderType? senderType,
    String? text,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return ClientMessage(
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

