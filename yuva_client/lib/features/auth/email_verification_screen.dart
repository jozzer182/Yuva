import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/components/yuva_button.dart';
import '../../core/providers.dart';

/// Pantalla de verificación de correo electrónico
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  Timer? _verificationTimer;
  Timer? _resendTimer;
  int _remainingSeconds = 900; // 15 minutos en segundos
  bool _canResend = true;
  bool _isCheckingVerification = false;
  bool _isSendingEmail = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
    _startVerificationCheck();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _resendTimer?.cancel();
    super.dispose();
  }

  /// Envía el correo de verificación
  Future<void> _sendVerificationEmail() async {
    if (_isSendingEmail) return;

    setState(() => _isSendingEmail = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Correo de verificación enviado'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Reiniciar countdown
        setState(() {
          _canResend = false;
          _remainingSeconds = 900;
        });
        _startResendCountdown();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Error al enviar correo';
        
        if (e is FirebaseAuthException) {
          if (e.code == 'too-many-requests') {
            errorMessage = 'Demasiados intentos. Espera unos minutos.';
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSendingEmail = false);
      }
    }
  }

  /// Inicia la verificación periódica del estado del email
  void _startVerificationCheck() {
    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _checkEmailVerified();
    });
  }

  /// Verifica si el email ha sido verificado
  Future<void> _checkEmailVerified() async {
    if (_isCheckingVerification) return;

    setState(() => _isCheckingVerification = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;

        if (updatedUser != null && updatedUser.emailVerified) {
          _verificationTimer?.cancel();
          
          // Actualizar el estado del usuario en el provider
          final authRepo = ref.read(authRepositoryProvider);
          final currentUser = await authRepo.getCurrentUser();
          ref.read(currentUserProvider.notifier).state = currentUser;

          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/main');
          }
        }
      }
    } catch (e) {
      // Error silencioso, seguir intentando
    } finally {
      if (mounted) {
        setState(() => _isCheckingVerification = false);
      }
    }
  }

  /// Inicia el contador regresivo para reenviar
  void _startResendCountdown() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  /// Formatea el tiempo restante en MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _handleLogout() async {
    await ref.read(authRepositoryProvider).signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Icono de email
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark 
                        ? YuvaColors.darkPrimaryTeal.withAlpha(51)
                        : YuvaColors.primaryTeal.withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_unread_outlined,
                    size: 80,
                    color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                  ),
                ),
                const SizedBox(height: 32),

                // Título
                Text(
                  'Verifica tu correo',
                  style: YuvaTypography.hero(
                    color: isDark ? Colors.white : YuvaColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Descripción
                Text(
                  'Hemos enviado un enlace de verificación a:',
                  style: YuvaTypography.body(
                    color: isDark ? Colors.white70 : YuvaColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? '',
                  style: YuvaTypography.body(
                    color: isDark ? Colors.white : YuvaColors.textPrimary,
                  ).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Instrucciones
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? YuvaColors.darkSurface.withAlpha(200)
                        : Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withAlpha(26)
                          : YuvaColors.textSecondary.withAlpha(51),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pasos a seguir:',
                            style: YuvaTypography.body(
                              color: isDark ? Colors.white : YuvaColors.textPrimary,
                            ).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildStep('1', 'Revisa tu bandeja de entrada', isDark),
                      const SizedBox(height: 8),
                      _buildStep('2', 'Abre el correo de verificación', isDark),
                      const SizedBox(height: 8),
                      _buildStep('3', 'Haz clic en el enlace de verificación', isDark),
                      const SizedBox(height: 8),
                      _buildStep('4', 'Regresa a esta pantalla', isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Estado de verificación
                if (_isCheckingVerification)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Verificando...',
                        style: YuvaTypography.caption(
                          color: isDark ? Colors.white60 : YuvaColors.textSecondary,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Verificación automática cada 3 segundos',
                    style: YuvaTypography.caption(
                      color: isDark ? Colors.white60 : YuvaColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 32),

                // Botón reenviar
                SizedBox(
                  width: double.infinity,
                  child: YuvaButton(
                    text: _canResend 
                        ? 'Reenviar correo'
                        : 'Reenviar en ${_formatTime(_remainingSeconds)}',
                    onPressed: _canResend && !_isSendingEmail ? _sendVerificationEmail : null,
                    isLoading: _isSendingEmail,
                    buttonStyle: YuvaButtonStyle.secondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Botón cerrar sesión
                TextButton(
                  onPressed: _handleLogout,
                  child: Text(
                    'Cerrar sesión',
                    style: YuvaTypography.body(
                      color: isDark ? Colors.white70 : YuvaColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Nota sobre spam
                Text(
                  '¿No ves el correo? Revisa tu carpeta de spam o correo no deseado.',
                  style: YuvaTypography.caption(
                    color: isDark ? Colors.white60 : YuvaColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text, bool isDark) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isDark
                ? YuvaColors.darkPrimaryTeal.withAlpha(77)
                : YuvaColors.primaryTeal.withAlpha(77),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: YuvaTypography.caption(
                color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
              ).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: YuvaTypography.body(
              color: isDark ? Colors.white70 : YuvaColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
