import '../models/client_conversation.dart';
import '../models/client_message.dart';
import '../repositories/client_conversations_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
/// This is a placeholder - real Firestore implementation is in firestore_client_conversations_repository.dart
class EmptyClientConversationsRepository implements ClientConversationsRepository {
  @override
  Future<List<ClientConversation>> getConversations() async {
    return [];
  }

  @override
  Future<ClientConversation?> getConversationForJob(String jobPostId) async {
    return null;
  }

  @override
  Future<List<ClientMessage>> getConversationMessages(String conversationId) async {
    return [];
  }

  @override
  Future<ClientMessage> sendMessage(String conversationId, String textFromClient) async {
    throw UnimplementedError('Messages not available in empty mode');
  }

  @override
  Future<void> markConversationRead(String conversationId) async {
    // No-op
  }

  @override
  Future<ClientConversation> createConversation({
    required String clientId,
    required String workerId,
    required String jobPostId,
    required String workerDisplayName,
    String? workerAvatarId,
    String? clientDisplayName,
  }) async {
    throw UnimplementedError('Conversations not available in empty mode');
  }
}

