import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phone;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phone,
    required this.createdAt,
  });

  String get firstName => name.split(' ').first;

  @override
  List<Object?> get props => [id, name, email, photoUrl, phone, createdAt];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phone,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
