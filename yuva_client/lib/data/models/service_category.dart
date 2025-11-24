import 'package:equatable/equatable.dart';

class ServiceCategory extends Equatable {
  final String id;
  final String nameKey;
  final String icon;
  final String color;

  const ServiceCategory({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [id, nameKey, icon, color];
}
