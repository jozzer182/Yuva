import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../design_system/colors.dart';
import '../../core/providers.dart';
import '../../data/models/user.dart' as app_user;
import '../auth/complete_profile_screen.dart';

/// Splash screen with yuva logo animation
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Check auth state and navigate accordingly
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check if user is already logged in
    final firebaseUser = FirebaseAuth.instance.currentUser;
    
    if (firebaseUser != null) {
      // User is logged in - load profile and navigate to main or complete profile
      await _handleLoggedInUser(firebaseUser);
    } else {
      // No user logged in - go to onboarding
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  Future<void> _handleLoggedInUser(User firebaseUser) async {
    try {
      // Load profile from Firestore
      final userProfileService = ref.read(userProfileServiceProvider);
      final firestoreProfile = await userProfileService.getWorkerProfile(firebaseUser.uid);
      
      // Create basic user model for auth state
      final user = app_user.User(
        id: firebaseUser.uid,
        name: firestoreProfile?.displayName ?? firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'Usuario',
        email: firebaseUser.email ?? '',
        photoUrl: firebaseUser.photoURL,
        phone: firestoreProfile?.phone ?? firebaseUser.phoneNumber,
        avatarId: firestoreProfile?.avatarId,
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      );
      
      // Update auth state
      ref.read(currentUserProvider.notifier).state = user;
      
      if (!mounted) return;
      
      // Check if worker profile exists and is complete
      if (firestoreProfile != null && firestoreProfile.isComplete) {
        // Load WorkerUser from Firestore profile
        final workerUser = firestoreProfile.toWorkerUser();
        await ref.read(workerUserProvider.notifier).setWorkerUser(workerUser);
        
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        // Profile incomplete - go to complete profile
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CompleteProfileScreen(authUser: user),
          ),
        );
      }
    } catch (e) {
      // On error, go to onboarding
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YuvaColors.darkBackground : YuvaColors.backgroundLight,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black26 : YuvaColors.shadowLight,
                              offset: const Offset(0, 8),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'icons/Android/Icon-192.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Yuva',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
