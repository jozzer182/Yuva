import 'package:equatable/equatable.dart';
import 'user.dart';

/// Complete worker user model combining Auth User with worker-specific fields
/// Stored in app state (not Firestore)
class WorkerUser extends Equatable {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? phone;
  final DateTime createdAt;
  
  // Worker-specific fields
  final String cityOrZone;
  final double baseHourlyRate;

  const WorkerUser({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.phone,
    required this.createdAt,
    required this.cityOrZone,
    required this.baseHourlyRate,
  });

  /// Create from Firebase Auth User with worker fields
  factory WorkerUser.fromAuthUser(
    User authUser, {
    required String cityOrZone,
    required double baseHourlyRate,
  }) {
    return WorkerUser(
      uid: authUser.id,
      displayName: authUser.name,
      email: authUser.email,
      photoUrl: authUser.photoUrl,
      phone: authUser.phone,
      createdAt: authUser.createdAt,
      cityOrZone: cityOrZone,
      baseHourlyRate: baseHourlyRate,
    );
  }

  /// Extract first name from displayName
  String get firstName => displayName.split(' ').first;

  /// Check if the worker profile has all required fields completed.
  /// Required fields for workers:
  /// - displayName (not empty or default)
  /// - email (not empty)
  /// - cityOrZone (not empty or default "No especificado")
  /// - baseHourlyRate (greater than 0)
  bool get isProfileComplete {
    final hasValidName = displayName.isNotEmpty && 
        displayName != 'Profesional' &&
        !displayName.contains('@'); // Not just email prefix
    final hasValidEmail = email.isNotEmpty;
    final hasValidZone = cityOrZone.isNotEmpty && 
        cityOrZone != 'No especificado';
    final hasValidRate = baseHourlyRate > 0;
    
    return hasValidName && hasValidEmail && hasValidZone && hasValidRate;
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        photoUrl,
        phone,
        createdAt,
        cityOrZone,
        baseHourlyRate,
      ];

  WorkerUser copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? phone,
    DateTime? createdAt,
    String? cityOrZone,
    double? baseHourlyRate,
  }) {
    return WorkerUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      cityOrZone: cityOrZone ?? this.cityOrZone,
      baseHourlyRate: baseHourlyRate ?? this.baseHourlyRate,
    );
  }
}

