import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_conversation.dart';
import '../models/worker_message.dart';
import '../repositories/worker_conversations_repository.dart';

/// Firestore implementation of WorkerConversationsRepository.
/// Conversations are stored in a top-level 'conversations' collection.
/// Messages are stored in 'conversations/{conversationId}/messages' subcollection.
class FirestoreWorkerConversationsRepository implements WorkerConversationsRepository {
  final FirebaseFirestore _firestore;
  final String _currentUserId;

  FirestoreWorkerConversationsRepository({
    FirebaseFirestore? firestore,
    required String currentUserId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentUserId = currentUserId;

  CollectionReference<Map<String, dynamic>> get _conversationsCollection =>
      _firestore.collection('conversations');

  CollectionReference<Map<String, dynamic>> _messagesCollection(String conversationId) =>
      _conversationsCollection.doc(conversationId).collection('messages');

  @override
  Future<List<WorkerConversation>> getConversations() async {
    final snapshot = await _conversationsCollection
        .where('workerId', isEqualTo: _currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => WorkerConversation.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<WorkerMessage>> getConversationMessages(String conversationId) async {
    final snapshot = await _messagesCollection(conversationId)
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => WorkerMessage.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<WorkerMessage> sendMessage(String conversationId, String textFromWorker) async {
    final now = DateTime.now();
    
    final messageData = {
      'conversationId': conversationId,
      'senderType': 'worker',
      'senderId': _currentUserId,
      'text': textFromWorker,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    };

    final docRef = await _messagesCollection(conversationId).add(messageData);

    // Update conversation's last message
    await _conversationsCollection.doc(conversationId).update({
      'lastMessagePreview': textFromWorker.length > 50 
          ? '${textFromWorker.substring(0, 50)}...' 
          : textFromWorker,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'clientUnreadCount': FieldValue.increment(1),
    });

    return WorkerMessage(
      id: docRef.id,
      conversationId: conversationId,
      senderType: MessageSenderType.worker,
      text: textFromWorker,
      createdAt: now,
      isRead: false,
    );
  }

  @override
  Future<void> markConversationRead(String conversationId) async {
    // Reset worker's unread count
    await _conversationsCollection.doc(conversationId).update({
      'workerUnreadCount': 0,
    });

    // Mark all messages from client as read
    final unreadMessages = await _messagesCollection(conversationId)
        .where('senderType', isEqualTo: 'client')
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Stream of conversations for real-time updates
  Stream<List<WorkerConversation>> watchConversations() {
    return _conversationsCollection
        .where('workerId', isEqualTo: _currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkerConversation.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Stream of messages for a conversation for real-time updates
  Stream<List<WorkerMessage>> watchMessages(String conversationId) {
    return _messagesCollection(conversationId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkerMessage.fromMap(doc.data(), doc.id))
            .toList());
  }
}
