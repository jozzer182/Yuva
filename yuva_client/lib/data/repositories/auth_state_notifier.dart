import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import '../services/user_profile_service.dart';

/// Auth state class
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool profileLoaded;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.profileLoaded = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? profileLoaded,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      profileLoaded: profileLoaded ?? this.profileLoaded,
    );
  }

  bool get isAuthenticated => user != null;
  bool get isAnonymous => user != null && user!.email.isEmpty;
}

/// Auth state notifier
/// Listens to Firebase auth state changes and exposes the current user
/// Also fetches additional profile data from Firestore
class AuthStateNotifier extends StateNotifier<AuthState> {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final UserProfileService _userProfileService;

  AuthStateNotifier({
    firebase_auth.FirebaseAuth? firebaseAuth,
    UserProfileService? userProfileService,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _userProfileService = userProfileService ?? UserProfileService(),
        super(const AuthState(isLoading: true)) {
    // Listen to auth state changes
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        state = const AuthState();
      } else {
        // First set basic user from Firebase Auth
        final basicUser = _mapFirebaseUserToUser(firebaseUser);
        state = AuthState(user: basicUser, isLoading: true);
        
        // Then try to fetch additional profile data from Firestore
        await _loadFirestoreProfile(firebaseUser.uid, basicUser);
      }
    }, onError: (error) {
      state = AuthState(errorMessage: error.toString());
    });
  }

  /// Load additional profile data from Firestore
  Future<void> _loadFirestoreProfile(String uid, User basicUser) async {
    try {
      final profile = await _userProfileService.getUserProfile(uid);
      
      if (profile != null) {
        // Merge Firestore data with Firebase Auth data
        final enrichedUser = basicUser.copyWith(
          name: profile.displayName.isNotEmpty ? profile.displayName : basicUser.name,
          phone: profile.phone ?? basicUser.phone,
        );
        state = AuthState(user: enrichedUser, profileLoaded: true);
      } else {
        // No Firestore profile yet - use basic user
        state = AuthState(user: basicUser, profileLoaded: false);
      }
    } catch (e) {
      // On error, just use basic user from Firebase Auth
      state = AuthState(user: basicUser, profileLoaded: false);
    }
  }

  /// Maps a FirebaseUser to our app's User model
  User _mapFirebaseUserToUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'Usuario',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
      phone: firebaseUser.phoneNumber,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }
}
