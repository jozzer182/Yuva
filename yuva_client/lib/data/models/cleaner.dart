import 'package:equatable/equatable.dart';

class Cleaner extends Equatable {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final int reviewCount;
  final double pricePerHour;
  final int yearsExperience;
  final List<String> specialties;
  final String bio;
  final bool isVerified;
  final bool isFeatured;

  const Cleaner({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.rating,
    required this.reviewCount,
    required this.pricePerHour,
    required this.yearsExperience,
    required this.specialties,
    required this.bio,
    this.isVerified = true,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        photoUrl,
        rating,
        reviewCount,
        pricePerHour,
        yearsExperience,
        specialties,
        bio,
        isVerified,
        isFeatured,
      ];
}
