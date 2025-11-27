import '../models/client_conversation.dart';
import '../models/client_message.dart';

abstract class ClientConversationsRepository {
  Future<List<ClientConversation>> getConversations();
  Future<ClientConversation?> getConversationForJob(String jobPostId);
  Future<List<ClientMessage>> getConversationMessages(String conversationId);
  Future<ClientMessage> sendMessage(String conversationId, String textFromClient);
  Future<void> markConversationRead(String conversationId);
  
  /// Creates a new conversation when a worker is hired
  Future<ClientConversation> createConversation({
    required String clientId,
    required String workerId,
    required String jobPostId,
    required String workerDisplayName,
    String? workerAvatarId,
    String? clientDisplayName,
  });
}

