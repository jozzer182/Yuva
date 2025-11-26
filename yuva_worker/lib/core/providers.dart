import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../data/models/user.dart';
import '../data/models/worker_profile.dart';
import '../data/models/worker_user.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/worker_job_feed_repository.dart';
import '../data/repositories/worker_profile_repository.dart';
import '../data/repositories/worker_earnings_repository.dart';
import '../data/repositories/worker_reviews_repository.dart';
import '../data/repositories/worker_conversations_repository.dart';
import '../data/repositories/worker_notifications_repository.dart';
import '../data/repositories/worker_active_jobs_repository.dart';
import '../data/repositories/worker_proposals_repository.dart';
import '../data/repositories/auth_state_notifier.dart';
import '../data/repositories/firebase_auth_repository.dart';
import '../data/repositories_dummy/dummy_worker_job_feed_repository.dart';
import '../data/repositories_dummy/dummy_worker_profile_repository.dart';
import '../data/repositories_dummy/dummy_worker_earnings_repository.dart';
import '../data/repositories_dummy/dummy_worker_reviews_repository.dart';
import '../data/repositories_dummy/dummy_worker_conversations_repository.dart';
import '../data/repositories_dummy/dummy_worker_notifications_repository.dart';
import '../data/repositories_dummy/dummy_worker_active_jobs_repository.dart';
import '../data/repositories_dummy/dummy_worker_proposals_repository.dart';
import '../data/repositories_empty/empty_worker_job_feed_repository.dart';
import '../data/repositories_empty/empty_worker_profile_repository.dart';
import '../data/repositories_empty/empty_worker_earnings_repository.dart';
import '../data/repositories_empty/empty_worker_reviews_repository.dart';
import '../data/repositories_empty/empty_worker_conversations_repository.dart';
import '../data/repositories_empty/empty_worker_notifications_repository.dart';
import '../data/repositories_empty/empty_worker_active_jobs_repository.dart';
import '../data/repositories_empty/empty_worker_proposals_repository.dart';
import 'settings_controller.dart';
import 'worker_user_controller.dart';
import '../data/services/user_profile_service.dart';

final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(firebaseAuth: ref.watch(firebaseAuthProvider));
});

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(firebaseAuth: ref.watch(firebaseAuthProvider));
});

final currentUserProvider = StateProvider<User?>((ref) {
  return ref.watch(authStateProvider).user;
});

final workerJobFeedRepositoryProvider = Provider<WorkerJobFeedRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerJobFeedRepository()
      : EmptyWorkerJobFeedRepository();
});

final workerProfileRepositoryProvider = Provider<WorkerProfileRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerProfileRepository(
          getCurrentUser: () => ref.watch(currentUserProvider),
        )
      : EmptyWorkerProfileRepository();
});

final workerEarningsRepositoryProvider = Provider<WorkerEarningsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerEarningsRepository()
      : EmptyWorkerEarningsRepository();
});

final workerReviewsRepositoryProvider = Provider<WorkerReviewsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerReviewsRepository()
      : EmptyWorkerReviewsRepository();
});

final workerConversationsRepositoryProvider = Provider<WorkerConversationsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerConversationsRepository()
      : EmptyWorkerConversationsRepository();
});

final workerNotificationsRepositoryProvider = Provider<WorkerNotificationsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerNotificationsRepository()
      : EmptyWorkerNotificationsRepository();
});

final workerActiveJobsRepositoryProvider = Provider<WorkerActiveJobsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerActiveJobsRepository()
      : EmptyWorkerActiveJobsRepository();
});

final workerProposalsRepositoryProvider = Provider<WorkerProposalsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerProposalsRepository()
      : EmptyWorkerProposalsRepository();
});

final currentWorkerProvider = StateProvider<WorkerProfile?>((ref) => null);

final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>((ref) => AppSettingsController());

final workerUserProvider = StateNotifierProvider<WorkerUserController, WorkerUser?>((ref) {
  return WorkerUserController();
});

// User Profile Service Provider (Firestore)
final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService();
});