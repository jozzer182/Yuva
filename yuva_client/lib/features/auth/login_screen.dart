import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/components/yuva_button.dart';
import '../../core/providers.dart';
import '../../core/responsive.dart';
import 'package:yuva/l10n/app_localizations.dart';
import 'email_verification_screen.dart';
import 'complete_profile_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      
      // Try to load profile from Firestore first
      final userProfileService = ref.read(userProfileServiceProvider);
      final firestoreProfile = await userProfileService.getUserProfile(user.id);
      
      // Merge Firestore data with auth user
      final enrichedUser = firestoreProfile != null
          ? user.copyWith(
              name: firestoreProfile.displayName.isNotEmpty ? firestoreProfile.displayName : user.name,
              phone: firestoreProfile.phone ?? user.phone,
              avatarId: firestoreProfile.avatarId,
            )
          : user;
      
      ref.read(currentUserProvider.notifier).state = enrichedUser;

      // Verificar si el email está verificado
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null && !firebaseUser.emailVerified) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EmailVerificationScreen(),
            ),
          );
        }
        return;
      }

      // Check if profile is complete
      if (!enrichedUser.isProfileComplete) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(authUser: enrichedUser),
            ),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } on FirebaseAuthMultiFactorException {
      // User has MFA enrolled but we don't support it yet
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.mfaNotSupported),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Muestra un mensaje de error amigable según el tipo de excepción
  void _showErrorSnackBar(dynamic error) {
    final l10n = AppLocalizations.of(context)!;
    String title;
    String? description;
    IconData icon = Icons.error_outline;
    Color backgroundColor = Colors.red;

    // Detectar errores de conexión
    if (_isNetworkError(error)) {
      title = l10n.errorNoInternet;
      description = l10n.errorNoInternetDescription;
      icon = Icons.wifi_off_rounded;
      backgroundColor = Colors.orange;
    } else if (error.toString().contains('cancelado') || 
               error.toString().contains('cancelled')) {
      title = l10n.errorGoogleSignInCancelled;
      icon = Icons.close_rounded;
      backgroundColor = Colors.grey;
    } else if (error.toString().contains('Google')) {
      title = l10n.errorGoogleSignInFailed;
      description = l10n.errorNoInternetDescription;
      icon = Icons.warning_amber_rounded;
    } else {
      title = error.toString().replaceAll('Exception: ', '');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (description != null)
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Verifica si el error es relacionado con la conexión a internet
  bool _isNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return error is SocketException ||
           errorString.contains('socketexception') ||
           errorString.contains('failed host lookup') ||
           errorString.contains('network') ||
           errorString.contains('no address associated') ||
           errorString.contains('connection refused') ||
           errorString.contains('connection failed') ||
           errorString.contains('no internet') ||
           errorString.contains('unreachable');
  }

  // guest mode removed

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithGoogle();
      
      // Try to load profile from Firestore first
      final userProfileService = ref.read(userProfileServiceProvider);
      final firestoreProfile = await userProfileService.getUserProfile(user.id);
      
      // Merge Firestore data with auth user
      final enrichedUser = firestoreProfile != null
          ? user.copyWith(
              name: firestoreProfile.displayName.isNotEmpty ? firestoreProfile.displayName : user.name,
              phone: firestoreProfile.phone ?? user.phone,
              avatarId: firestoreProfile.avatarId,
            )
          : user;
      
      ref.read(currentUserProvider.notifier).state = enrichedUser;

      // Check if profile is complete (client needs phone)
      if (!enrichedUser.isProfileComplete) {
        // Navigate to complete profile screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(authUser: enrichedUser),
            ),
          );
        }
        return;
      }

      // Google Sign-In ya verifica el email automáticamente
      // Profile is complete, go to main
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [YuvaColors.darkBackground, YuvaColors.darkSurface]
                : [YuvaColors.backgroundWarm, YuvaColors.backgroundLight],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveUtils.maxFormWidth(context),
              ),
              child: SingleChildScrollView(
                padding: ResponsiveUtils.padding(context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const SizedBox(height: 40),
                  Text(
                    l10n.login,
                    style: YuvaTypography.hero(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.continueWithEmail,
                    style: YuvaTypography.body(color: YuvaColors.textSecondary),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: YuvaButton(
                      text: l10n.login,
                      onPressed: _isLoading ? null : _handleLogin,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // guest mode removed
                  const SizedBox(height: 24),
                  // Divider with "OR"
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'O',
                          style: YuvaTypography.body(color: YuvaColors.textSecondary),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                      icon: Image.network(
                        'https://www.google.com/favicon.ico',
                        height: 24,
                        width: 24,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24),
                      ),
                      label: const Text('Continuar con Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: YuvaColors.textSecondary.withAlpha(77)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/signup');
                      },
                      child: Text.rich(
                        TextSpan(
                          text: '${l10n.dontHaveAccount} ',
                          style: YuvaTypography.body(color: YuvaColors.textSecondary),
                          children: [
                            TextSpan(
                              text: l10n.signup,
                              style: YuvaTypography.body(
                                color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.forgotPasswordLink,
                        style: YuvaTypography.body(
                          color: YuvaColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
