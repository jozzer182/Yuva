import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/components/yuva_button.dart';
import '../../core/providers.dart';
import '../../core/responsive.dart';
import '../../data/models/worker_user.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
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
      ref.read(currentUserProvider.notifier).state = user;

      // Try to load WorkerUser from Firestore first
      final userProfileService = ref.read(userProfileServiceProvider);
      final firestoreProfile = await userProfileService.getWorkerProfile(user.id);
      
      if (firestoreProfile != null && firestoreProfile.isComplete) {
        // Use Firestore data - profile exists and is complete
        final workerUser = firestoreProfile.toWorkerUser();
        await ref.read(workerUserProvider.notifier).setWorkerUser(workerUser);
      } else {
        // Fall back to local data or create new
        final existingWorkerUser = ref.read(workerUserProvider);
        if (existingWorkerUser == null || existingWorkerUser.uid != user.id) {
          // Create basic WorkerUser if doesn't exist
          final workerUser = WorkerUser.fromAuthUser(
            user,
            cityOrZone: firestoreProfile?.cityOrZone ?? 'No especificado',
            baseHourlyRate: firestoreProfile?.baseHourlyRate ?? 0.0,
            avatarId: firestoreProfile?.avatarId,
          );
          await ref.read(workerUserProvider.notifier).setWorkerUser(workerUser);
        } else {
          // Update auth fields in existing WorkerUser
          await ref.read(workerUserProvider.notifier).updateFromAuthUser(user);
        }
      }

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
      final currentWorkerUser = ref.read(workerUserProvider);
      if (currentWorkerUser != null && !currentWorkerUser.isProfileComplete) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(authUser: user),
            ),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }



  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithGoogle();
      ref.read(currentUserProvider.notifier).state = user;

      // Try to load WorkerUser from Firestore first
      final userProfileService = ref.read(userProfileServiceProvider);
      final firestoreProfile = await userProfileService.getWorkerProfile(user.id);
      
      if (firestoreProfile != null && firestoreProfile.isComplete) {
        // Use Firestore data - profile exists and is complete
        final workerUser = firestoreProfile.toWorkerUser();
        await ref.read(workerUserProvider.notifier).setWorkerUser(workerUser);
        
        // Profile is complete, go to main
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/main');
        }
        return;
      }
      
      // No complete Firestore profile - check local or create new
      final existingWorkerUser = ref.read(workerUserProvider);
      final workerUser = WorkerUser.fromAuthUser(
        user,
        cityOrZone: firestoreProfile?.cityOrZone ?? existingWorkerUser?.cityOrZone ?? 'No especificado',
        baseHourlyRate: firestoreProfile?.baseHourlyRate ?? existingWorkerUser?.baseHourlyRate ?? 0.0,
        avatarId: firestoreProfile?.avatarId ?? existingWorkerUser?.avatarId,
      );
      await ref.read(workerUserProvider.notifier).setWorkerUser(workerUser);

      // Check if profile is complete
      if (!workerUser.isProfileComplete) {
        // Navigate to complete profile screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(authUser: user),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    print('=== APPLE SIGN-IN WORKER: Button pressed ===');
    setState(() => _isLoading = true);

    try {
      print('=== APPLE SIGN-IN WORKER: Calling authRepo.signInWithApple() ===');
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithApple();
      print('=== APPLE SIGN-IN WORKER: Success! User ID: ${user.id} ===');
      ref.read(currentUserProvider.notifier).state = user;

      // Try to load WorkerUser from Firestore first
      final userProfileService = ref.read(userProfileServiceProvider);
      final firestoreProfile = await userProfileService.getWorkerProfile(user.id);
      
      if (firestoreProfile != null && firestoreProfile.isComplete) {
        // Use Firestore data - profile exists and is complete
        final workerUser = firestoreProfile.toWorkerUser();
        await ref.read(workerUserProvider.notifier).setWorkerUser(workerUser);
        
        // Profile is complete, go to main
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/main');
        }
        return;
      }
      
      // No complete Firestore profile - check local or create new
      final existingWorkerUser = ref.read(workerUserProvider);
      final workerUser = WorkerUser.fromAuthUser(
        user,
        cityOrZone: firestoreProfile?.cityOrZone ?? existingWorkerUser?.cityOrZone ?? 'No especificado',
        baseHourlyRate: firestoreProfile?.baseHourlyRate ?? existingWorkerUser?.baseHourlyRate ?? 0.0,
        avatarId: firestoreProfile?.avatarId ?? existingWorkerUser?.avatarId,
      );
      await ref.read(workerUserProvider.notifier).setWorkerUser(workerUser);

      // Check if profile is complete
      if (!workerUser.isProfileComplete) {
        // Navigate to complete profile screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(authUser: user),
            ),
          );
        }
        return;
      }

      // Apple Sign-In ya verifica el email automáticamente
      // Profile is complete, go to main
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e, stackTrace) {
      print('=== APPLE SIGN-IN WORKER ERROR: $e ===');
      print('=== APPLE SIGN-IN WORKER STACK TRACE: $stackTrace ===');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      print('=== APPLE SIGN-IN WORKER: Flow completed ===');
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
                      // Apple Sign-In Button (iOS only)
                      if (Platform.isIOS) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: SignInWithAppleButton(
                            onPressed: _isLoading ? () {} : _handleAppleSignIn,
                            style: isDark 
                                ? SignInWithAppleButtonStyle.white 
                                : SignInWithAppleButtonStyle.black,
                            text: 'Continuar con Apple',
                          ),
                        ),
                      ],
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
