import '../models/worker_conversation.dart';
import '../models/worker_message.dart';
import '../repositories/worker_conversations_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyWorkerConversationsRepository implements WorkerConversationsRepository {
  @override
  Future<List<WorkerConversation>> getConversations() async {
    return [];
  }

  @override
  Future<List<WorkerMessage>> getConversationMessages(String conversationId) async {
    return [];
  }

  @override
  Future<WorkerMessage> sendMessage(String conversationId, String textFromWorker) async {
    throw UnimplementedError('Messages not available in empty mode');
  }

  @override
  Future<void> markConversationRead(String conversationId) async {
    // No-op
  }
}

