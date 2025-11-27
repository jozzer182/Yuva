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

/// Provider that returns the count of active proposals for a job.
/// Active proposals exclude withdrawn and rejected statuses.
final activeProposalCountProvider =
    FutureProvider.autoDispose.family<int, String>((ref, jobId) async {
  final proposals = await ref.watch(proposalsForJobProvider(jobId).future);
  return proposals.length;
});

/// Provider to fetch worker's avatarId from Firestore by workerId.
/// Used when proposal doesn't have denormalized workerAvatarId.
final workerAvatarIdProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, workerId) async {
  if (workerId.isEmpty) return null;
  final userProfileService = ref.watch(userProfileServiceProvider);
  final profile = await userProfileService.getAnyUserProfile(workerId);
  return profile?.avatarId;
});
