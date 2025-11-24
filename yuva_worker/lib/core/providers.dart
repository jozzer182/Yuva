import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../data/models/user.dart';
import '../data/models/worker_profile.dart';
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
import 'settings_controller.dart';

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
  return DummyWorkerJobFeedRepository();
});

final workerProfileRepositoryProvider = Provider<WorkerProfileRepository>((ref) {
  return DummyWorkerProfileRepository();
});

final workerEarningsRepositoryProvider = Provider<WorkerEarningsRepository>((ref) {
  return DummyWorkerEarningsRepository();
});

final workerReviewsRepositoryProvider = Provider<WorkerReviewsRepository>((ref) {
  return DummyWorkerReviewsRepository();
});

final workerConversationsRepositoryProvider = Provider<WorkerConversationsRepository>((ref) {
  return DummyWorkerConversationsRepository();
});

final workerNotificationsRepositoryProvider = Provider<WorkerNotificationsRepository>((ref) {
  return DummyWorkerNotificationsRepository();
});

final workerActiveJobsRepositoryProvider = Provider<WorkerActiveJobsRepository>((ref) {
  return DummyWorkerActiveJobsRepository();
});

final workerProposalsRepositoryProvider = Provider<WorkerProposalsRepository>((ref) {
  return DummyWorkerProposalsRepository();
});

final currentWorkerProvider = StateProvider<WorkerProfile?>((ref) => null);

final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>((ref) => AppSettingsController());