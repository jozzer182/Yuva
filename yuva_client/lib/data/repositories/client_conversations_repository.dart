import '../models/client_conversation.dart';
import '../models/client_message.dart';

abstract class ClientConversationsRepository {
  Future<List<ClientConversation>> getConversations();
  Future<List<ClientMessage>> getConversationMessages(String conversationId);
  Future<ClientMessage> sendMessage(String conversationId, String textFromClient);
  Future<void> markConversationRead(String conversationId);
}

