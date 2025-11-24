import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';

/// Auth state class
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  bool get isAuthenticated => user != null;
  bool get isAnonymous => user != null && user!.email.isEmpty;
}

/// Auth state notifier
/// Listens to Firebase auth state changes and exposes the current user
class AuthStateNotifier extends StateNotifier<AuthState> {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthStateNotifier({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        super(const AuthState(isLoading: true)) {
    // Listen to auth state changes
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        state = const AuthState();
      } else {
        state = AuthState(user: _mapFirebaseUserToUser(firebaseUser));
      }
    }, onError: (error) {
      state = AuthState(errorMessage: error.toString());
    });
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
