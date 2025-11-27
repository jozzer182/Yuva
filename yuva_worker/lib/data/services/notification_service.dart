import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for creating notifications for users.
/// This is a client-side service that writes notifications directly to Firestore.
/// In production, this should be replaced with Cloud Functions for better security.
class WorkerNotificationService {
  final FirebaseFirestore _firestore;

  WorkerNotificationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Notify a client that a new proposal was received
  Future<void> notifyClientNewProposal({
    required String clientId,
    required String jobPostId,
    required String proposalId,
    required String jobTitle,
    required String workerName,
  }) async {
    await _firestore
        .collection('users')
        .doc(clientId)
        .collection('notifications')
        .add({
      'type': 'newProposal',
      'title': 'Nueva propuesta recibida',
      'body': '$workerName envió una propuesta para "$jobTitle"',
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'jobPostId': jobPostId,
      'proposalId': proposalId,
    });
  }

  /// Notify a client about a new message from worker
  Future<void> notifyClientNewMessage({
    required String clientId,
    required String conversationId,
    required String senderName,
    required String messagePreview,
  }) async {
    await _firestore
        .collection('users')
        .doc(clientId)
        .collection('notifications')
        .add({
      'type': 'newMessage',
      'title': 'Nuevo mensaje de $senderName',
      'body': messagePreview.length > 50
          ? '${messagePreview.substring(0, 50)}...'
          : messagePreview,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'conversationId': conversationId,
    });
  }

  /// Notify a client that a job was marked as completed by worker
  Future<void> notifyClientJobCompleted({
    required String clientId,
    required String activeJobId,
    required String jobTitle,
    required String workerName,
  }) async {
    await _firestore
        .collection('users')
        .doc(clientId)
        .collection('notifications')
        .add({
      'type': 'jobStatusChange',
      'title': 'Trabajo completado',
      'body': '$workerName marcó "$jobTitle" como completado',
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'activeJobId': activeJobId,
    });
  }
}
