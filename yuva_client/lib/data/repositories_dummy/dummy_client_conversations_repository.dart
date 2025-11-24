import '../repositories/client_conversations_repository.dart';
import '../models/client_conversation.dart';
import '../models/client_message.dart';

class DummyClientConversationsRepository implements ClientConversationsRepository {
  // Datos dummy en memoria - usando IDs consistentes con marketplace_memory_store
  final List<ClientConversation> _conversations = [
    ClientConversation(
      id: 'conv_client_job1',
      jobPostId: 'job_open_apartment',
      workerDisplayName: 'Luisa Rincón',
      lastMessagePreview: 'Hola, me gustaría confirmar los detalles del trabajo',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 1,
    ),
    ClientConversation(
      id: 'conv_client_job2',
      jobPostId: 'job_hired_house',
      workerDisplayName: 'Mateo Silva',
      lastMessagePreview: 'Perfecto, nos vemos mañana a las 8am',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
    ClientConversation(
      id: 'conv_client_job3',
      activeJobId: 'active_job_office', // Para trabajo activo
      workerDisplayName: 'Camila Ortega',
      lastMessagePreview: 'El trabajo está completado, ¿puedes revisar?',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 2,
    ),
  ];

  final Map<String, List<ClientMessage>> _messages = {
    'conv_client_job1': [
      ClientMessage(
        id: 'msg_client_1',
        conversationId: 'conv_client_job1',
        senderType: MessageSenderType.worker,
        text: 'Hola, me gustaría confirmar los detalles del trabajo',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      ClientMessage(
        id: 'msg_client_2',
        conversationId: 'conv_client_job1',
        senderType: MessageSenderType.client,
        text: 'Hola Luisa, claro. ¿Qué necesitas saber?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        isRead: true,
      ),
    ],
    'conv_client_job2': [
      ClientMessage(
        id: 'msg_client_3',
        conversationId: 'conv_client_job2',
        senderType: MessageSenderType.worker,
        text: 'Perfecto, nos vemos mañana a las 8am',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ],
    'conv_client_job3': [
      ClientMessage(
        id: 'msg_client_4',
        conversationId: 'conv_client_job3',
        senderType: MessageSenderType.worker,
        text: 'El trabajo está completado, ¿puedes revisar?',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      ClientMessage(
        id: 'msg_client_5',
        conversationId: 'conv_client_job3',
        senderType: MessageSenderType.system,
        text: 'El profesional ha marcado el trabajo como completado',
        createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
        isRead: false,
      ),
    ],
  };

  @override
  Future<List<ClientConversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_conversations);
  }

  @override
  Future<List<ClientMessage>> getConversationMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_messages[conversationId] ?? []);
  }

  @override
  Future<ClientMessage> sendMessage(String conversationId, String textFromClient) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final newMessage = ClientMessage(
      id: 'msg_client_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderType: MessageSenderType.client,
      text: textFromClient,
      createdAt: DateTime.now(),
      isRead: true,
    );

    // Agregar mensaje a la lista
    _messages[conversationId] = [...(_messages[conversationId] ?? []), newMessage];

    // Actualizar conversación
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      _conversations[conversationIndex] = conversation.copyWith(
        lastMessagePreview: textFromClient,
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
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      _conversations[conversationIndex] = conversation.copyWith(unreadCount: 0);
    }
  }
}

