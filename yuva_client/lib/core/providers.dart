import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:yuva/data/models/user.dart';
import 'package:yuva/data/repositories/auth_repository.dart';
import 'package:yuva/data/repositories/firebase_auth_repository.dart';
import 'package:yuva/data/repositories/auth_state_notifier.dart';
import 'package:yuva/data/repositories/booking_repository.dart';
import 'package:yuva/data/repositories/category_repository.dart';
import 'package:yuva/data/repositories/cleaner_repository.dart';
import 'package:yuva/data/repositories/job_post_repository.dart';
import 'package:yuva/data/repositories/pro_summary_repository.dart';
import 'package:yuva/data/repositories/proposal_repository.dart';
import 'package:yuva/data/repositories/ratings_repository.dart';
import 'package:yuva/data/repositories/client_conversations_repository.dart';
import 'package:yuva/data/repositories/client_notifications_repository.dart';
import 'package:yuva/data/repositories/client_active_job_repository.dart';
import 'package:yuva/data/repositories_dummy/booking_repository_dummy.dart';
import 'package:yuva/data/repositories_dummy/dummy_category_repository.dart';
import 'package:yuva/data/repositories_dummy/dummy_cleaner_repository.dart';
import 'package:yuva/data/repositories_dummy/dummy_job_post_repository.dart';
import 'package:yuva/data/repositories_dummy/dummy_pro_summary_repository.dart';
import 'package:yuva/data/repositories_dummy/dummy_proposal_repository.dart';
import 'package:yuva/data/repositories_dummy/dummy_ratings_repository.dart';
import 'package:yuva/data/repositories_dummy/dummy_client_conversations_repository.dart';
import 'package:yuva/data/repositories_dummy/dummy_client_notifications_repository.dart';
import 'package:yuva/data/repositories_dummy/dummy_client_active_job_repository.dart';
import 'package:yuva/data/services/booking_price_calculator.dart';

import 'settings_controller.dart';

// Firebase Auth Provider
final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

// Auth Repository Provider (now using Firebase)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(firebaseAuth: ref.watch(firebaseAuthProvider));
});

// Auth State Provider - listens to Firebase auth state changes
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(firebaseAuth: ref.watch(firebaseAuthProvider));
});

// Legacy currentUserProvider for backward compatibility
// Consider migrating to authStateProvider in the future
final currentUserProvider = StateProvider<User?>((ref) {
  return ref.watch(authStateProvider).user;
});

// Other repository providers (still using dummy implementations)
final cleanerRepositoryProvider = Provider<CleanerRepository>((ref) {
  return DummyCleanerRepository();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DummyCategoryRepository();
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return DummyBookingRepository();
});

final bookingPriceCalculatorProvider = Provider<BookingPriceCalculator>((ref) {
  return const BookingPriceCalculator();
});

final ratingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  return DummyRatingsRepository();
});

final jobPostRepositoryProvider = Provider<JobPostRepository>((ref) {
  return DummyJobPostRepository();
});

final proposalRepositoryProvider = Provider<ProposalRepository>((ref) {
  return DummyProposalRepository();
});

final proSummaryRepositoryProvider = Provider<ProSummaryRepository>((ref) {
  return DummyProSummaryRepository();
});

final clientConversationsRepositoryProvider = Provider<ClientConversationsRepository>((ref) {
  return DummyClientConversationsRepository();
});

final clientNotificationsRepositoryProvider = Provider<ClientNotificationsRepository>((ref) {
  return DummyClientNotificationsRepository();
});

final clientActiveJobRepositoryProvider = Provider<ClientActiveJobRepository>((ref) {
  return DummyClientActiveJobRepository();
});

// App settings (locale + toggles)
final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>((ref) => AppSettingsController());
