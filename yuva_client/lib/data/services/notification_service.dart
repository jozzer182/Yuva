import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for creating notifications for users.
/// This is a client-side service that writes notifications directly to Firestore.
/// In production, this should be replaced with Cloud Functions for better security.
class NotificationService {
  final FirebaseFirestore _firestore;

  NotificationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Notify a worker that they have been hired for a job
  Future<void> notifyWorkerHired({
    required String workerId,
    required String jobPostId,
    required String jobTitle,
    required String clientName,
  }) async {
    await _firestore
        .collection('workers')
        .doc(workerId)
        .collection('notifications')
        .add({
      'type': 'proposalStatusChange',
      'title': '¡Felicidades! Has sido contratado',
      'body': '$clientName te ha contratado para "$jobTitle"',
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'jobPostId': jobPostId,
    });
  }

  /// Notify a worker that their proposal was rejected
  Future<void> notifyWorkerRejected({
    required String workerId,
    required String jobPostId,
    required String jobTitle,
  }) async {
    await _firestore
        .collection('workers')
        .doc(workerId)
        .collection('notifications')
        .add({
      'type': 'proposalStatusChange',
      'title': 'Propuesta no seleccionada',
      'body': 'Tu propuesta para "$jobTitle" no fue seleccionada',
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'jobPostId': jobPostId,
    });
  }

  /// Notify a worker that their proposal was shortlisted
  Future<void> notifyWorkerShortlisted({
    required String workerId,
    required String jobPostId,
    required String jobTitle,
  }) async {
    await _firestore
        .collection('workers')
        .doc(workerId)
        .collection('notifications')
        .add({
      'type': 'proposalStatusChange',
      'title': 'Tu propuesta fue preseleccionada',
      'body': 'Tu propuesta para "$jobTitle" ha sido preseleccionada',
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'jobPostId': jobPostId,
    });
  }

  /// Notify a worker about a new message
  Future<void> notifyWorkerNewMessage({
    required String workerId,
    required String conversationId,
    required String senderName,
    required String messagePreview,
  }) async {
    await _firestore
        .collection('workers')
        .doc(workerId)
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

  /// Notify a client about a new proposal
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

  /// Notify a client about a new message
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
}
