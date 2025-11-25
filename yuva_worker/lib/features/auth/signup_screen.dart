import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/components/yuva_button.dart';
import '../../core/providers.dart';
import '../../core/responsive.dart';
import '../../data/models/worker_user.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import 'email_verification_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityOrZoneController = TextEditingController();
  final _baseHourlyRateController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityOrZoneController.dispose();
    _baseHourlyRateController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signUpWithEmail(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
      ref.read(currentUserProvider.notifier).state = user;

      // Create WorkerUser with additional worker fields
      final cityOrZone = _cityOrZoneController.text.trim();
      final baseHourlyRateText = _baseHourlyRateController.text.trim();
      final baseHourlyRate = double.tryParse(baseHourlyRateText) ?? 0.0;
      
      final workerUser = WorkerUser.fromAuthUser(
        user,
        cityOrZone: cityOrZone.isEmpty ? 'No especificado' : cityOrZone,
        baseHourlyRate: baseHourlyRate,
      );
      
      await ref.read(workerUserProvider.notifier).setWorkerUser(workerUser);

      // Redirigir a pantalla de verificación de email
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const EmailVerificationScreen(),
          ),
        );
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
                        l10n.signup,
                        style: YuvaTypography.hero(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.continueWithEmail,
                        style: YuvaTypography.body(color: YuvaColors.textSecondary),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: l10n.name,
                          prefixIcon: const Icon(Icons.person_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cityOrZoneController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: l10n.cityOrZone,
                          hintText: l10n.cityOrZoneHint,
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu ciudad o zona';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _baseHourlyRateController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.baseHourlyRate,
                          hintText: 'Ej: 45000',
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu tarifa base por hora';
                          }
                          final rate = double.tryParse(value);
                          if (rate == null || rate <= 0) {
                            return 'Por favor ingresa un valor válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: YuvaButton(
                          text: l10n.signup,
                          onPressed: _isLoading ? null : _handleSignUp,
                          isLoading: _isLoading,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/login');
                          },
                          child: Text.rich(
                            TextSpan(
                              text: '${l10n.alreadyHaveAccount} ',
                              style: YuvaTypography.body(color: YuvaColors.textSecondary),
                              children: [
                                TextSpan(
                                  text: l10n.login,
                                  style: YuvaTypography.body(
                                    color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
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
