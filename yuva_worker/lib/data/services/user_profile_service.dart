import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_user.dart';

/// Service for managing worker profiles in Firestore
/// Handles reading and writing worker profile data
class UserProfileService {
  final FirebaseFirestore _firestore;
  
  static const String _usersCollection = 'users';
  static const String _roleWorker = 'worker';

  UserProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get worker profile from Firestore
  /// Returns null if document doesn't exist
  Future<WorkerUserProfile?> getWorkerProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      
      return WorkerUserProfile.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      // Log error but don't crash - profile might not exist yet
      return null;
    }
  }

  /// Save or update worker profile in Firestore
  /// Uses merge to avoid overwriting existing fields
  Future<void> saveWorkerProfile({
    required String uid,
    required String displayName,
    required String email,
    String? photoUrl,
    String? phone,
    String? avatarId,
    required DateTime createdAt,
    required String cityOrZone,
    required double baseHourlyRate,
  }) async {
    final now = DateTime.now();
    
    final data = <String, dynamic>{
      'uid': uid,
      'role': _roleWorker,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'avatarId': avatarId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(now),
      'cityOrZone': cityOrZone,
      'baseHourlyRate': baseHourlyRate,
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

  /// Get any user's profile by UID (worker or client)
  /// Used to fetch client avatar when not denormalized in conversation
  Future<String?> getUserAvatarId(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      
      return doc.data()!['avatarId'] as String?;
    } catch (e) {
      return null;
    }
  }
}

/// Worker profile data from Firestore
class WorkerUserProfile {
  final String uid;
  final String role;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? phone;
  final String? avatarId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String cityOrZone;
  final double baseHourlyRate;

  const WorkerUserProfile({
    required this.uid,
    required this.role,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.phone,
    this.avatarId,
    required this.createdAt,
    required this.updatedAt,
    required this.cityOrZone,
    required this.baseHourlyRate,
  });

  factory WorkerUserProfile.fromFirestore(Map<String, dynamic> data, String docId) {
    return WorkerUserProfile(
      uid: data['uid'] as String? ?? docId,
      role: data['role'] as String? ?? 'worker',
      displayName: data['displayName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      phone: data['phone'] as String?,
      avatarId: data['avatarId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cityOrZone: data['cityOrZone'] as String? ?? 'No especificado',
      baseHourlyRate: (data['baseHourlyRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to app's WorkerUser model
  WorkerUser toWorkerUser() {
    return WorkerUser(
      uid: uid,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      phone: phone,
      avatarId: avatarId,
      createdAt: createdAt,
      cityOrZone: cityOrZone,
      baseHourlyRate: baseHourlyRate,
    );
  }

  /// Check if profile has all required worker fields
  bool get isComplete {
    final hasValidName = displayName.isNotEmpty && 
        displayName != 'Profesional' &&
        !displayName.contains('@');
    final hasValidEmail = email.isNotEmpty;
    final hasValidZone = cityOrZone.isNotEmpty && 
        cityOrZone != 'No especificado';
    final hasValidRate = baseHourlyRate > 0;
    
    return hasValidName && hasValidEmail && hasValidZone && hasValidRate;
  }
}
