import 'package:equatable/equatable.dart';

/// Worker profile model
class WorkerProfile extends Equatable {
  final String id;
  final String displayName;
  final String areaBaseLabel;
  final List<String> offeredServiceTypeIds;
  final double baseHourlyRate;
  final String? bioKey;
  final double ratingAverage;
  final int ratingCount;

  const WorkerProfile({
    required this.id,
    required this.displayName,
    required this.areaBaseLabel,
    required this.offeredServiceTypeIds,
    required this.baseHourlyRate,
    this.bioKey,
    this.ratingAverage = 0.0,
    this.ratingCount = 0,
  });

  WorkerProfile copyWith({
    String? id,
    String? displayName,
    String? areaBaseLabel,
    List<String>? offeredServiceTypeIds,
    double? baseHourlyRate,
    String? bioKey,
    double? ratingAverage,
    int? ratingCount,
  }) {
    return WorkerProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      areaBaseLabel: areaBaseLabel ?? this.areaBaseLabel,
      offeredServiceTypeIds: offeredServiceTypeIds ?? this.offeredServiceTypeIds,
      baseHourlyRate: baseHourlyRate ?? this.baseHourlyRate,
      bioKey: bioKey ?? this.bioKey,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        areaBaseLabel,
        offeredServiceTypeIds,
        baseHourlyRate,
        bioKey,
        ratingAverage,
        ratingCount,
      ];
}
