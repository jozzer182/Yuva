import 'package:equatable/equatable.dart';

class WorkerEarningsSummary extends Equatable {
  final double totalThisWeek;
  final double totalThisMonth;
  final int completedJobsThisMonth;
  final double avgEarningPerJob;
  final String currencyCode;

  const WorkerEarningsSummary({
    required this.totalThisWeek,
    required this.totalThisMonth,
    required this.completedJobsThisMonth,
    required this.avgEarningPerJob,
    this.currencyCode = 'COP',
  });

  @override
  List<Object?> get props => [totalThisWeek, totalThisMonth, completedJobsThisMonth, avgEarningPerJob, currencyCode];
}