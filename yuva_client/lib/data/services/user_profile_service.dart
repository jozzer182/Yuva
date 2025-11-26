import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

/// Service for managing user profiles in Firestore
/// Handles reading and writing client profile data
class UserProfileService {
  final FirebaseFirestore _firestore;
  
  static const String _usersCollection = 'users';
  static const String _roleClient = 'client';

  UserProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get user profile from Firestore
  /// Returns null if document doesn't exist
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      
      return UserProfile.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      // Log error but don't crash - profile might not exist yet
      return null;
    }
  }

  /// Save or update user profile in Firestore
  /// Uses merge to avoid overwriting existing fields
  Future<void> saveUserProfile({
    required String uid,
    required String displayName,
    required String email,
    String? photoUrl,
    String? phone,
    required DateTime createdAt,
  }) async {
    final now = DateTime.now();
    
    final data = <String, dynamic>{
      'uid': uid,
      'role': _roleClient,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(now),
    };

    // Remove null values to avoid overwriting with null
    data.removeWhere((key, value) => value == null);

    await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  /// Update specific profile fields
  Future<void> updateProfileFields(String uid, Map<String, dynamic> fields) async {
    fields['updatedAt'] = Timestamp.fromDate(DateTime.now());
    
    await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .update(fields);
  }
}

/// User profile data from Firestore
/// Extends the basic User model with Firestore-specific fields
class UserProfile {
  final String uid;
  final String role;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.uid,
    required this.role,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String docId) {
    return UserProfile(
      uid: data['uid'] as String? ?? docId,
      role: data['role'] as String? ?? 'client',
      displayName: data['displayName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      phone: data['phone'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to app's User model
  User toUser() {
    return User(
      id: uid,
      name: displayName,
      email: email,
      photoUrl: photoUrl,
      phone: phone,
      createdAt: createdAt,
    );
  }

  /// Check if profile has all required client fields
  bool get isComplete {
    final hasValidName = displayName.isNotEmpty && 
        displayName != 'Usuario' &&
        !displayName.contains('@');
    final hasValidEmail = email.isNotEmpty;
    final hasValidPhone = phone != null && phone!.isNotEmpty;
    
    return hasValidName && hasValidEmail && hasValidPhone;
  }
}
