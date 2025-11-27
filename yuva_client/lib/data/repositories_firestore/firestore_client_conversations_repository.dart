import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_conversation.dart';
import '../models/client_message.dart';
import '../repositories/client_conversations_repository.dart';

/// Firestore implementation of ClientConversationsRepository.
/// Conversations are stored in a top-level 'conversations' collection.
/// Messages are stored in 'conversations/{conversationId}/messages' subcollection.
class FirestoreClientConversationsRepository implements ClientConversationsRepository {
  final FirebaseFirestore _firestore;
  final String _currentUserId;

  FirestoreClientConversationsRepository({
    FirebaseFirestore? firestore,
    required String currentUserId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentUserId = currentUserId;

  CollectionReference<Map<String, dynamic>> get _conversationsCollection =>
      _firestore.collection('conversations');

  CollectionReference<Map<String, dynamic>> _messagesCollection(String conversationId) =>
      _conversationsCollection.doc(conversationId).collection('messages');

  @override
  Future<List<ClientConversation>> getConversations() async {
    final snapshot = await _conversationsCollection
        .where('clientId', isEqualTo: _currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ClientConversation.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<ClientConversation?> getConversationForJob(String jobPostId) async {
    final snapshot = await _conversationsCollection
        .where('clientId', isEqualTo: _currentUserId)
        .where('jobPostId', isEqualTo: jobPostId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return ClientConversation.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
  }

  @override
  Future<List<ClientMessage>> getConversationMessages(String conversationId) async {
    final snapshot = await _messagesCollection(conversationId)
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => ClientMessage.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<ClientMessage> sendMessage(String conversationId, String textFromClient) async {
    final now = DateTime.now();
    
    final messageData = {
      'conversationId': conversationId,
      'senderType': 'client',
      'senderId': _currentUserId,
      'text': textFromClient,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    };

    final docRef = await _messagesCollection(conversationId).add(messageData);

    // Update conversation's last message
    await _conversationsCollection.doc(conversationId).update({
      'lastMessagePreview': textFromClient.length > 50 
          ? '${textFromClient.substring(0, 50)}...' 
          : textFromClient,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'workerUnreadCount': FieldValue.increment(1),
    });

    return ClientMessage(
      id: docRef.id,
      conversationId: conversationId,
      senderType: MessageSenderType.client,
      text: textFromClient,
      createdAt: now,
      isRead: false,
    );
  }

  @override
  Future<void> markConversationRead(String conversationId) async {
    // Reset client's unread count
    await _conversationsCollection.doc(conversationId).update({
      'clientUnreadCount': 0,
    });

    // Mark all messages from worker as read
    final unreadMessages = await _messagesCollection(conversationId)
        .where('senderType', isEqualTo: 'worker')
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
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
    // Check if conversation already exists for this job
    final existing = await getConversationForJob(jobPostId);
    if (existing != null) {
      return existing;
    }

    final now = DateTime.now();
    final initialMessage = '¡Conversación iniciada!';

    final conversationData = {
      'clientId': clientId,
      'workerId': workerId,
      'jobPostId': jobPostId,
      'workerDisplayName': workerDisplayName,
      'workerAvatarId': workerAvatarId,
      'clientDisplayName': clientDisplayName,
      'lastMessagePreview': initialMessage,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'clientUnreadCount': 0,
      'workerUnreadCount': 1,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _conversationsCollection.add(conversationData);

    // Create initial system message
    await _messagesCollection(docRef.id).add({
      'conversationId': docRef.id,
      'senderType': 'system',
      'text': '¡$clientDisplayName ha contratado a $workerDisplayName para este trabajo!',
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': true,
    });

    return ClientConversation(
      id: docRef.id,
      clientId: clientId,
      workerId: workerId,
      jobPostId: jobPostId,
      workerDisplayName: workerDisplayName,
      workerAvatarId: workerAvatarId,
      lastMessagePreview: initialMessage,
      lastMessageAt: now,
      unreadCount: 0,
    );
  }

  /// Stream of conversations for real-time updates
  Stream<List<ClientConversation>> watchConversations() {
    return _conversationsCollection
        .where('clientId', isEqualTo: _currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClientConversation.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Stream of messages for a conversation for real-time updates
  Stream<List<ClientMessage>> watchMessages(String conversationId) {
    return _messagesCollection(conversationId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClientMessage.fromMap(doc.data(), doc.id))
            .toList());
  }
}
