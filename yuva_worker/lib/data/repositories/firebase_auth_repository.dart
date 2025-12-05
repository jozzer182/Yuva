import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
  Future<User> signInWithApple() async {
    try {
      print('=== APPLE AUTH WORKER: Requesting Apple credentials ===');
      // Request Apple Sign-In credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print('=== APPLE AUTH WORKER: Credential received from Apple ===');
      print('=== APPLE AUTH WORKER: identityToken length: ${appleCredential.identityToken?.length} ===');
      print('=== APPLE AUTH WORKER: authorizationCode length: ${appleCredential.authorizationCode.length} ===');
      print('=== APPLE AUTH WORKER: email: ${appleCredential.email} ===');
      print('=== APPLE AUTH WORKER: userIdentifier: ${appleCredential.userIdentifier} ===');

      // Check if identityToken is null
      if (appleCredential.identityToken == null) {
        print('=== APPLE AUTH WORKER ERROR: identityToken is null ===');
        throw Exception('Apple no devolvió un token de identidad. Por favor intenta de nuevo.');
      }

      // Create an OAuth credential from the Apple credential
      print('=== APPLE AUTH WORKER: Creating Firebase OAuthCredential ===');
      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      print('=== APPLE AUTH WORKER: Calling Firebase signInWithCredential ===');
      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        print('=== APPLE AUTH WORKER ERROR: userCredential.user is null ===');
        throw Exception('Error al iniciar sesión con Apple');
      }
      print('=== APPLE AUTH WORKER: Firebase user created - UID: ${userCredential.user!.uid} ===');

      // Apple only provides name on first sign-in, so update display name if available
      final displayName = appleCredential.givenName != null && appleCredential.familyName != null
          ? '${appleCredential.givenName} ${appleCredential.familyName}'
          : null;

      if (displayName != null && userCredential.user!.displayName == null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload();
      }

      final updatedUser = _firebaseAuth.currentUser;
      return _mapFirebaseUserToUser(updatedUser ?? userCredential.user!);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('Inicio de sesión con Apple cancelado');
      }
      throw 'Error al iniciar sesión con Apple: ${e.message}';
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw 'Error al iniciar sesión con Apple: ${e.toString()}';
    }
  }

  /// Generates a cryptographically secure random nonce
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }

      // Delete the Firebase Auth user
      await user.delete();
      
      // Sign out from Google if applicable
      await _googleSignIn.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('Por seguridad, necesitas volver a iniciar sesión antes de eliminar tu cuenta');
      }
      throw _mapFirebaseException(e);
    } catch (e) {
      throw 'Error al eliminar la cuenta: ${e.toString()}';
    }
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
