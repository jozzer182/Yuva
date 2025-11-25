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
import 'package:yuva/data/repositories_empty/empty_cleaner_repository.dart';
import 'package:yuva/data/repositories_empty/empty_job_post_repository.dart';
import 'package:yuva/data/repositories_empty/empty_booking_repository.dart';
import 'package:yuva/data/repositories_empty/empty_proposal_repository.dart';
import 'package:yuva/data/repositories_empty/empty_client_conversations_repository.dart';
import 'package:yuva/data/repositories_empty/empty_client_notifications_repository.dart';
import 'package:yuva/data/repositories_empty/empty_ratings_repository.dart';
import 'package:yuva/data/repositories_empty/empty_pro_summary_repository.dart';
import 'package:yuva/data/repositories_empty/empty_client_active_job_repository.dart';
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

// Other repository providers - switch between dummy and empty based on dummy mode
final cleanerRepositoryProvider = Provider<CleanerRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyCleanerRepository() : EmptyCleanerRepository();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DummyCategoryRepository(); // Categories can stay dummy
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyBookingRepository() : EmptyBookingRepository();
});

final bookingPriceCalculatorProvider = Provider<BookingPriceCalculator>((ref) {
  return const BookingPriceCalculator();
});

final ratingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyRatingsRepository() : EmptyRatingsRepository();
});

final jobPostRepositoryProvider = Provider<JobPostRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyJobPostRepository() : EmptyJobPostRepository();
});

final proposalRepositoryProvider = Provider<ProposalRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyProposalRepository() : EmptyProposalRepository();
});

final proSummaryRepositoryProvider = Provider<ProSummaryRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyProSummaryRepository() : EmptyProSummaryRepository();
});

final clientConversationsRepositoryProvider = Provider<ClientConversationsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyClientConversationsRepository() : EmptyClientConversationsRepository();
});

final clientNotificationsRepositoryProvider = Provider<ClientNotificationsRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyClientNotificationsRepository() : EmptyClientNotificationsRepository();
});

final clientActiveJobRepositoryProvider = Provider<ClientActiveJobRepository>((ref) {
  final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));
  return isDummyMode ? DummyClientActiveJobRepository() : EmptyClientActiveJobRepository();
});

// App settings (locale + toggles)
final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>((ref) => AppSettingsController());
