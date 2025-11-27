/// Model representing a blocked user relationship.
/// Stored in 'blocked_users' collection for legal/audit purposes.
class BlockedUser {
  final String id;
  final String blockerId;       // User who initiated the block
  final String blockerType;     // 'client' or 'worker'
  final String blockedId;       // User who was blocked
  final String blockedType;     // 'client' or 'worker'
  final String? conversationId; // Optional: conversation that triggered the block
  final String? reason;         // Optional: reason provided by blocker
  final DateTime createdAt;

  BlockedUser({
    required this.id,
    required this.blockerId,
    required this.blockerType,
    required this.blockedId,
    required this.blockedType,
    this.conversationId,
    this.reason,
    required this.createdAt,
  });

  factory BlockedUser.fromMap(Map<String, dynamic> map, String id) {
    return BlockedUser(
      id: id,
      blockerId: map['blockerId'] as String? ?? '',
      blockerType: map['blockerType'] as String? ?? '',
      blockedId: map['blockedId'] as String? ?? '',
      blockedType: map['blockedType'] as String? ?? '',
      conversationId: map['conversationId'] as String?,
      reason: map['reason'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blockerId': blockerId,
      'blockerType': blockerType,
      'blockedId': blockedId,
      'blockedType': blockedType,
      'conversationId': conversationId,
      'reason': reason,
      'createdAt': createdAt,
    };
  }
}
