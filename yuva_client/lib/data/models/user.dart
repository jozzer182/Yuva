import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phone;
  final String? avatarId;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phone,
    this.avatarId,
    required this.createdAt,
  });

  String get firstName => name.split(' ').first;

  /// Check if the client profile has all required fields completed.
  /// Required fields for clients:
  /// - name (not empty or default)
  /// - email (not empty)
  /// - phone (not empty) - required for service coordination
  bool get isProfileComplete {
    final hasValidName = name.isNotEmpty && 
        name != 'Usuario' &&
        !name.contains('@'); // Not just email prefix
    final hasValidEmail = email.isNotEmpty;
    final hasValidPhone = phone != null && phone!.isNotEmpty;
    
    return hasValidName && hasValidEmail && hasValidPhone;
  }

  @override
  List<Object?> get props => [id, name, email, photoUrl, phone, avatarId, createdAt];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phone,
    String? avatarId,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      avatarId: avatarId ?? this.avatarId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
