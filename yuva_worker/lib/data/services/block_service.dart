import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blocked_user.dart';

/// Service for managing user blocks.
/// Blocks are stored in 'blocked_users' collection for audit/legal purposes.
/// Each user also has a 'blocked_ids' array in their profile for quick filtering.
class BlockService {
  final FirebaseFirestore _firestore;
  final String _currentUserId;
  final String _currentUserType; // 'client' or 'worker'

  BlockService({
    FirebaseFirestore? firestore,
    required String currentUserId,
    required String currentUserType,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentUserId = currentUserId,
        _currentUserType = currentUserType;

  /// Block a user and archive the conversation.
  /// Returns the ID of the created block record.
  Future<String> blockUser({
    required String blockedUserId,
    required String blockedUserType,
    String? conversationId,
    String? reason,
  }) async {
    final batch = _firestore.batch();
    
    // 1. Create block record in 'blocked_users' collection (for legal/audit)
    final blockRef = _firestore.collection('blocked_users').doc();
    batch.set(blockRef, {
      'blockerId': _currentUserId,
      'blockerType': _currentUserType,
      'blockedId': blockedUserId,
      'blockedType': blockedUserType,
      'conversationId': conversationId,
      'reason': reason,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Add blocked user to blocker's blocked_ids array (for quick filtering)
    final blockerCollection = _currentUserType == 'client' ? 'users' : 'workers';
    final blockerRef = _firestore.collection(blockerCollection).doc(_currentUserId);
    batch.update(blockerRef, {
      'blockedIds': FieldValue.arrayUnion([blockedUserId]),
    });

    // 3. Mark conversation as blocked (if provided)
    if (conversationId != null && conversationId.isNotEmpty) {
      final convRef = _firestore.collection('conversations').doc(conversationId);
      batch.update(convRef, {
        'blockedBy': _currentUserId,
        'blockedAt': FieldValue.serverTimestamp(),
        'isBlocked': true,
      });
    }

    await batch.commit();
    return blockRef.id;
  }

  /// Get list of user IDs that the current user has blocked.
  Future<List<String>> getBlockedUserIds() async {
    final collection = _currentUserType == 'client' ? 'users' : 'workers';
    final doc = await _firestore.collection(collection).doc(_currentUserId).get();
    
    if (!doc.exists || doc.data() == null) return [];
    
    final data = doc.data()!;
    final blockedIds = data['blockedIds'] as List<dynamic>?;
    return blockedIds?.map((e) => e.toString()).toList() ?? [];
  }

  /// Check if a specific user is blocked by the current user.
  Future<bool> isUserBlocked(String userId) async {
    final blockedIds = await getBlockedUserIds();
    return blockedIds.contains(userId);
  }

  /// Get all block records created by the current user (for admin/legal purposes).
  Future<List<BlockedUser>> getMyBlockRecords() async {
    final snapshot = await _firestore
        .collection('blocked_users')
        .where('blockerId', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BlockedUser.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Stream of blocked user IDs for real-time filtering.
  Stream<List<String>> watchBlockedUserIds() {
    final collection = _currentUserType == 'client' ? 'users' : 'workers';
    return _firestore
        .collection(collection)
        .doc(_currentUserId)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return <String>[];
      final blockedIds = doc.data()!['blockedIds'] as List<dynamic>?;
      return blockedIds?.map((e) => e.toString()).toList() ?? [];
    });
  }
}
