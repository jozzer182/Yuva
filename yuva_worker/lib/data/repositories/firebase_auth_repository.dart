import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';
import 'auth_repository.dart';

/// Firebase Authentication implementation for workers
class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    
    return _mapFirebaseUserToUser(firebaseUser);
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Error al iniciar sesión');
      }

      return _mapFirebaseUserToUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<User> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Error al crear cuenta');
      }

      // Update display name
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw Exception('Error al actualizar perfil');
      }

      return _mapFirebaseUserToUser(updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Inicio de sesión con Google cancelado');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Error al iniciar sesión con Google');
      }

      return _mapFirebaseUserToUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw 'Error al iniciar sesión con Google: ${e.toString()}';
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // Multi-Factor Authentication Implementation
  
  @override
  Future<void> enrollMFA(String phoneNumber) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Start MFA enrollment session
      final session = await user.multiFactor.getSession();

      // Send verification code to phone number
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          throw _mapFirebaseException(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Verification ID will be handled in the UI layer
        },
        codeAutoRetrievalTimeout: (_) {},
        multiFactorSession: session,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<String> verifyMFAEnrollment(String verificationId, String smsCode) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Create phone auth credential
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Create multi-factor assertion
      final multiFactorAssertion = firebase_auth.PhoneMultiFactorGenerator.getAssertion(credential);

      // Enroll the second factor
      await user.multiFactor.enroll(multiFactorAssertion, displayName: 'Teléfono');

      return 'Autenticación de dos factores configurada exitosamente';
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<User> verifyMFASignIn(String verificationId, String smsCode, dynamic resolver) async {
    try {
      // Create phone auth credential
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Create multi-factor assertion
      final multiFactorAssertion = firebase_auth.PhoneMultiFactorGenerator.getAssertion(credential);

      // Resolve the sign-in
      final userCredential = await (resolver as firebase_auth.MultiFactorResolver)
          .resolveSignIn(multiFactorAssertion);

      if (userCredential.user == null) {
        throw Exception('Error al verificar código MFA');
      }

      return _mapFirebaseUserToUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  bool isMultiFactorUser() {
    // Note: enrolledFactors API not available in firebase_auth 5.7.0
    // For now, we assume MFA is NOT enabled by default
    // Users must explicitly enroll through the MFA enrollment screen
    // This will be properly implemented when upgrading to firebase_auth 6.0+
    return false;
  }

  @override
  Future<void> unenrollMFA(String factorUid) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Note: This is a placeholder implementation
      // Full implementation requires firebase_auth >= 6.0.0 for enrolledFactors API
      // For now, this will throw an error to indicate upgrade is needed
      throw UnimplementedError(
        'La funcionalidad de desactivar MFA requiere actualizar firebase_auth a versión 6.0+'
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw 'Error al desactivar autenticación de dos factores: ${e.toString()}';
    }
  }

  /// Maps a FirebaseUser to our app's User model
  User _mapFirebaseUserToUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'Profesional',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
      phone: firebaseUser.phoneNumber,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// Maps Firebase exceptions to user-friendly error messages in Spanish
  String _mapFirebaseException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe una cuenta con este correo electrónico';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo electrónico';
      case 'invalid-email':
        return 'El correo electrónico no es válido';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Por favor, intenta más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet';
      default:
        return 'Error: ${e.message ?? 'Ocurrió un error inesperado'}';
    }
  }
}
