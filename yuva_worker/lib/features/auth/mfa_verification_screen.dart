import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../core/providers.dart';

/// Pantalla para verificar código MFA durante el login
class MFAVerificationScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final firebase_auth.MultiFactorResolver resolver;
  final String? phoneNumber;

  const MFAVerificationScreen({
    super.key,
    required this.verificationId,
    required this.resolver,
    this.phoneNumber,
  });

  @override
  ConsumerState<MFAVerificationScreen> createState() => _MFAVerificationScreenState();
}

class _MFAVerificationScreenState extends ConsumerState<MFAVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _canResend = false;
    _resendCountdown = 60;
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) {
          _canResend = true;
        }
      });
      
      return _resendCountdown > 0;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Ingresa el código de verificación';
      });
      return;
    }

    if (_codeController.text.trim().length != 6) {
      setState(() {
        _errorMessage = 'El código debe tener 6 dígitos';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authRepositoryProvider).verifyMFASignIn(
        widget.verificationId,
        _codeController.text.trim(),
        widget.resolver,
      );

      if (mounted) {
        // Navigate to main screen on success
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _mapFirebaseError(e);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final hint = widget.resolver.hints.first as firebase_auth.PhoneMultiFactorInfo;
      
      await firebase_auth.FirebaseAuth.instance.verifyPhoneNumber(
        multiFactorSession: widget.resolver.session,
        multiFactorInfo: hint,
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          setState(() {
            _errorMessage = _mapFirebaseError(e);
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
          });
          _startCountdown();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Código reenviado'),
              backgroundColor: Colors.green,
            ),
          );
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _mapFirebaseError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'Código incorrecto. Verifica e intenta de nuevo.';
      case 'code-expired':
        return 'El código ha expirado. Solicita uno nuevo.';
      case 'session-expired':
        return 'La sesión ha expirado. Inicia sesión nuevamente.';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera unos minutos.';
      default:
        return 'Error: ${e.message ?? 'Ocurrió un error inesperado'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Identidad'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Security icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            const Text(
              'Autenticación de Dos Factores',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Subtitle
            Text(
              widget.phoneNumber != null
                  ? 'Ingresa el código enviado a ${widget.phoneNumber}'
                  : 'Ingresa el código de verificación enviado a tu teléfono',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Code input
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Código de Verificación',
                hintText: '123456',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              maxLength: 6,
              enabled: !_isLoading,
              autofocus: true,
              onSubmitted: (_) => _verifyCode(),
            ),
            const SizedBox(height: 32),

            // Verify button
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Verificar',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 16),

            // Resend code
            Center(
              child: _canResend
                  ? TextButton.icon(
                      onPressed: _isLoading ? null : _resendCode,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reenviar Código'),
                    )
                  : Text(
                      'Puedes reenviar el código en $_resendCountdown seg',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
            ),

            const SizedBox(height: 32),

            // Help card
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.help_outline, color: Colors.grey.shade700, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          '¿No recibiste el código?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Verifica que tu teléfono tenga señal\n'
                      '• Espera unos segundos, puede tardar\n'
                      '• Revisa tu carpeta de spam\n'
                      '• Solicita reenviar el código',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
