import '../models/worker_conversation.dart';
import '../models/worker_message.dart';

abstract class WorkerConversationsRepository {
  Future<List<WorkerConversation>> getConversations();
  Future<List<WorkerMessage>> getConversationMessages(String conversationId);
  Future<WorkerMessage> sendMessage(String conversationId, String textFromWorker);
  Future<void> markConversationRead(String conversationId);
}

