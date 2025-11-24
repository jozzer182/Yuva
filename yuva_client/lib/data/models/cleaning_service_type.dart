import 'package:equatable/equatable.dart';

/// Represents a type of cleaning service offered in the app.
/// Uses localization keys so future backends can supply translations easily.
class CleaningServiceType extends Equatable {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String iconName;
  final double baseRate;

  const CleaningServiceType({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.iconName,
    required this.baseRate,
  });

  @override
  List<Object> get props => [id, titleKey, descriptionKey, iconName, baseRate];
}
