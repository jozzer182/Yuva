import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/job_models.dart';

final jobPostsProvider = FutureProvider.autoDispose<List<JobPost>>((ref) async {
  final repository = ref.watch(jobPostRepositoryProvider);
  final userId = ref.watch(currentUserProvider)?.id ?? 'demo-user';
  return repository.getJobPostsForClient(userId);
});

final jobPostProvider = FutureProvider.autoDispose.family<JobPost?, String>((ref, jobId) async {
  final repository = ref.watch(jobPostRepositoryProvider);
  return repository.getJobPostById(jobId);
});

final proposalsForJobProvider =
    FutureProvider.autoDispose.family<List<Proposal>, String>((ref, jobId) async {
  final repository = ref.watch(proposalRepositoryProvider);
  return repository.getProposalsForJob(jobId);
});

final proSummariesProvider = FutureProvider.autoDispose<List<ProSummary>>((ref) async {
  final repository = ref.watch(proSummaryRepositoryProvider);
  return repository.getPros();
});

final proSummaryProvider = FutureProvider.autoDispose.family<ProSummary?, String>((ref, proId) async {
  final repository = ref.watch(proSummaryRepositoryProvider);
  return repository.getProById(proId);
});
