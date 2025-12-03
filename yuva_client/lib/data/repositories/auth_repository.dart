import '../models/user.dart';

/// Abstract authentication repository
/// In Phase 2/3, implement with Firebase Auth
abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password, String name);
  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
  Future<void> signOut();
  Future<User> continueAsGuest();
  
  // Multi-Factor Authentication
  Future<void> enrollMFA(String phoneNumber);
  Future<String> verifyMFAEnrollment(String verificationId, String smsCode);
  Future<User> verifyMFASignIn(String verificationId, String smsCode, dynamic resolver);
  bool isMultiFactorUser();
  Future<void> unenrollMFA(String factorUid);
}
