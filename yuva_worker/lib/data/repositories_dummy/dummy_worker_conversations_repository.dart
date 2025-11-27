import '../repositories/worker_conversations_repository.dart';
import '../models/worker_conversation.dart';
import '../models/worker_message.dart';

class DummyWorkerConversationsRepository
    implements WorkerConversationsRepository {
  // Datos dummy en memoria
  final List<WorkerConversation> _conversations = [
    WorkerConversation(
      id: 'conv1',
      clientId: 'dummy_client_1',
      workerId: 'dummy_worker_1',
      jobPostId: 'job1',
      clientDisplayName: 'María García',
      lastMessagePreview: 'Perfecto, nos vemos mañana a las 9am',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 2,
    ),
    WorkerConversation(
      id: 'conv2',
      clientId: 'dummy_client_2',
      workerId: 'dummy_worker_1',
      jobPostId: 'job2',
      clientDisplayName: 'Carlos López',
      lastMessagePreview: 'Gracias por el excelente trabajo',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
    WorkerConversation(
      id: 'conv3',
      clientId: 'dummy_client_3',
      workerId: 'dummy_worker_1',
      jobPostId: 'job3',
      clientDisplayName: 'Ana Martínez',
      lastMessagePreview: '¿Podrías llegar 30 minutos antes?',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 1,
    ),
  ];

  final Map<String, List<WorkerMessage>> _messages = {
    'conv1': [
      WorkerMessage(
        id: 'msg1',
        conversationId: 'conv1',
        senderType: MessageSenderType.client,
        text: 'Hola, me gustaría confirmar la cita de mañana',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      WorkerMessage(
        id: 'msg2',
        conversationId: 'conv1',
        senderType: MessageSenderType.worker,
        text: 'Hola María, sí, confirmado para mañana a las 9am',
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: -1)),
        isRead: true,
      ),
      WorkerMessage(
        id: 'msg3',
        conversationId: 'conv1',
        senderType: MessageSenderType.client,
        text: 'Perfecto, nos vemos mañana a las 9am',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      WorkerMessage(
        id: 'msg4',
        conversationId: 'conv1',
        senderType: MessageSenderType.system,
        text: 'El cliente ha visto tu mensaje',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
    ],
    'conv2': [
      WorkerMessage(
        id: 'msg5',
        conversationId: 'conv2',
        senderType: MessageSenderType.client,
        text: 'Gracias por el excelente trabajo',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ],
    'conv3': [
      WorkerMessage(
        id: 'msg6',
        conversationId: 'conv3',
        senderType: MessageSenderType.client,
        text: '¿Podrías llegar 30 minutos antes?',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
      ),
    ],
  };

  @override
  Future<List<WorkerConversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_conversations);
  }

  @override
  Future<List<WorkerMessage>> getConversationMessages(
    String conversationId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_messages[conversationId] ?? []);
  }

  @override
  Future<WorkerMessage> sendMessage(
    String conversationId,
    String textFromWorker,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final newMessage = WorkerMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderType: MessageSenderType.worker,
      text: textFromWorker,
      createdAt: DateTime.now(),
      isRead: true,
    );

    // Agregar mensaje a la lista
    _messages[conversationId] = [
      ...(_messages[conversationId] ?? []),
      newMessage,
    ];

    // Actualizar conversación
    final conversationIndex = _conversations.indexWhere(
      (c) => c.id == conversationId,
    );
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      _conversations[conversationIndex] = conversation.copyWith(
        lastMessagePreview: textFromWorker,
        lastMessageAt: DateTime.now(),
      );
    }

    return newMessage;
  }

  @override
  Future<void> markConversationRead(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Marcar todos los mensajes como leídos
    final messages = _messages[conversationId] ?? [];
    for (var i = 0; i < messages.length; i++) {
      _messages[conversationId]![i] = messages[i].copyWith(isRead: true);
    }

    // Actualizar unreadCount en la conversación
    final conversationIndex = _conversations.indexWhere(
      (c) => c.id == conversationId,
    );
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      _conversations[conversationIndex] = conversation.copyWith(unreadCount: 0);
    }
  }

  @override
  Stream<List<WorkerMessage>> watchMessages(String conversationId) {
    // En modo dummy, emitimos los mensajes actuales una vez
    return Stream.value(List.from(_messages[conversationId] ?? []));
  }
}
