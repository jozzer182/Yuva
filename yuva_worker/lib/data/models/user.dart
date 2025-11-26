import 'package:equatable/equatable.dart';

/// User model representing authenticated worker
/// This represents the Firebase Auth user, not the full worker profile
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
