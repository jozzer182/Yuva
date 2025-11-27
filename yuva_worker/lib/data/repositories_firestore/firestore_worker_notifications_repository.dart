import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_notification.dart';
import '../repositories/worker_notifications_repository.dart';

/// Firestore implementation of WorkerNotificationsRepository.
/// Notifications are stored in 'workers/{userId}/notifications' subcollection.
class FirestoreWorkerNotificationsRepository implements WorkerNotificationsRepository {
  final FirebaseFirestore _firestore;
  final String _currentUserId;

  FirestoreWorkerNotificationsRepository({
    FirebaseFirestore? firestore,
    required String currentUserId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentUserId = currentUserId;

  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection('workers').doc(_currentUserId).collection('notifications');

  @override
  Future<List<WorkerNotification>> getNotifications() async {
    if (_currentUserId.isEmpty) return [];
    
    final snapshot = await _notificationsCollection
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => WorkerNotification.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    if (_currentUserId.isEmpty) return;
    
    await _notificationsCollection.doc(notificationId).update({
      'isRead': true,
    });
  }

  @override
  Future<void> markAllRead() async {
    if (_currentUserId.isEmpty) return;
    
    final unreadNotifications = await _notificationsCollection
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in unreadNotifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Stream of notifications for real-time updates
  Stream<List<WorkerNotification>> watchNotifications() {
    if (_currentUserId.isEmpty) return Stream.value([]);
    
    return _notificationsCollection
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkerNotification.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Get count of unread notifications
  Future<int> getUnreadCount() async {
    if (_currentUserId.isEmpty) return 0;
    
    final snapshot = await _notificationsCollection
        .where('isRead', isEqualTo: false)
        .count()
        .get();
    
    return snapshot.count ?? 0;
  }

  /// Stream of unread count for real-time badge updates
  Stream<int> watchUnreadCount() {
    if (_currentUserId.isEmpty) return Stream.value(0);
    
    return _notificationsCollection
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Create a notification (typically called by Cloud Functions, but useful for testing)
  Future<void> createNotification(WorkerNotification notification) async {
    if (_currentUserId.isEmpty) return;
    
    await _notificationsCollection.add({
      ...notification.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
