import '../models/user.dart';
import '../repositories/auth_repository.dart';

/// Dummy implementation of AuthRepository
/// Returns in-memory fake data with simulated delays
class DummyAuthRepository implements AuthRepository {
  User? _currentUser;

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: 'María García',
      email: email,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<User> signUpWithEmail(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<User> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Usuario de Google',
      email: 'google@example.com',
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  @override
  Future<User> continueAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = User(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Invitado',
      email: 'guest@yuva.app',
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  // MFA methods - dummy implementations
  @override
  Future<void> enrollMFA(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('MFA no disponible en modo dummy');
  }

  @override
  Future<String> verifyMFAEnrollment(String verificationId, String smsCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('MFA no disponible en modo dummy');
  }

  @override
  Future<User> verifyMFASignIn(String verificationId, String smsCode, dynamic resolver) async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('MFA no disponible en modo dummy');
  }

  @override
  bool isMultiFactorUser() {
    return false;
  }

  @override
  Future<void> unenrollMFA(String factorUid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('MFA no disponible en modo dummy');
  }
}
