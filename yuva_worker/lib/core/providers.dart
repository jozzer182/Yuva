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
import '../data/repositories_empty/empty_worker_profile_repository.dart';
import '../data/repositories_empty/empty_worker_earnings_repository.dart';
import '../data/repositories_empty/empty_worker_reviews_repository.dart';
import '../data/repositories_empty/empty_worker_conversations_repository.dart';
import '../data/repositories_empty/empty_worker_notifications_repository.dart';
import '../data/repositories_empty/empty_worker_active_jobs_repository.dart';
import '../data/repositories_firestore/firestore_worker_job_feed_repository.dart';
import '../data/repositories_firestore/firestore_worker_proposals_repository.dart';
import '../data/repositories_firestore/firestore_worker_conversations_repository.dart';
import '../data/repositories_firestore/firestore_worker_notifications_repository.dart';
import 'settings_controller.dart';
import 'worker_user_controller.dart';
import '../data/services/user_profile_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/block_service.dart';

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
  if (isDummyMode) {
    return DummyWorkerJobFeedRepository();
  }
  // Use Firestore repository when dummy mode is OFF
  final currentUser = ref.watch(currentUserProvider);
  final workerId = currentUser?.id ?? '';
  return FirestoreWorkerJobFeedRepository(currentWorkerId: workerId);
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
  if (isDummyMode) {
    return DummyWorkerConversationsRepository();
  }
  // Use Firestore repository when dummy mode is OFF
  final workerUser = ref.watch(workerUserProvider);
  final userId = workerUser?.uid ?? '';
  return FirestoreWorkerConversationsRepository(currentUserId: userId);
});

final workerNotificationsRepositoryProvider = Provider<WorkerNotificationsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  if (isDummyMode) {
    return DummyWorkerNotificationsRepository();
  }
  // Use Firestore repository when dummy mode is OFF
  final workerUser = ref.watch(workerUserProvider);
  final userId = workerUser?.uid ?? '';
  return FirestoreWorkerNotificationsRepository(currentUserId: userId);
});

final workerActiveJobsRepositoryProvider = Provider<WorkerActiveJobsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode
      ? DummyWorkerActiveJobsRepository()
      : EmptyWorkerActiveJobsRepository();
});

final workerProposalsRepositoryProvider = Provider<WorkerProposalsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  if (isDummyMode) {
    return DummyWorkerProposalsRepository();
  }
  // Use Firestore repository when dummy mode is OFF
  // Prefer workerUserProvider for complete profile data including avatarId
  final workerUser = ref.watch(workerUserProvider);
  final currentUser = ref.watch(currentUserProvider);
  final workerId = workerUser?.uid ?? currentUser?.id ?? '';
  final workerName = workerUser?.displayName ?? currentUser?.name;
  final workerPhotoUrl = workerUser?.photoUrl ?? currentUser?.photoUrl;
  final workerAvatarId = workerUser?.avatarId ?? currentUser?.avatarId;
  final initials = workerName != null && workerName.isNotEmpty
      ? workerName.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
      : null;
  return FirestoreWorkerProposalsRepository(
    currentWorkerId: workerId,
    workerDisplayName: workerName,
    workerAvatarInitials: initials,
    workerPhotoUrl: workerPhotoUrl,
    workerAvatarId: workerAvatarId,
  );
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

// Worker Notification Service Provider
final workerNotificationServiceProvider = Provider<WorkerNotificationService>((ref) {
  return WorkerNotificationService();
});

// Block Service Provider
final blockServiceProvider = Provider<BlockService>((ref) {
  final workerUser = ref.watch(workerUserProvider);
  return BlockService(
    currentUserId: workerUser?.uid ?? '',
    currentUserType: 'worker',
  );
});

// Provider for blocked user IDs (for filtering)
final blockedUserIdsProvider = FutureProvider<List<String>>((ref) async {
  final blockService = ref.watch(blockServiceProvider);
  return blockService.getBlockedUserIds();
});