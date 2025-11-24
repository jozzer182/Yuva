import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Pantalla para configurar autenticación de dos factores con TOTP (Google Authenticator)
class TOTPEnrollmentScreen extends ConsumerStatefulWidget {
  const TOTPEnrollmentScreen({super.key});

  @override
  ConsumerState<TOTPEnrollmentScreen> createState() => _TOTPEnrollmentScreenState();
}

class _TOTPEnrollmentScreenState extends ConsumerState<TOTPEnrollmentScreen> {
  final _codeController = TextEditingController();
  
  bool _isLoading = false;
  bool _qrGenerated = false;
  String? _totpSecret;
  String? _qrCodeUrl;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _generateTOTPSecret();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _generateTOTPSecret() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      print('[TOTP] Iniciando generación de secreto TOTP para usuario: ${user.uid}');
      
      // Get TOTP enrollment info
      final session = await user.multiFactor.getSession();
      print('[TOTP] Sesión MFA obtenida');
      
      final totpSecret = await firebase_auth.TotpMultiFactorGenerator.generateSecret(session);
      print('[TOTP] Secreto TOTP generado: ${totpSecret.secretKey}');
      
      // Generate QR code URL for authenticator apps
      final accountName = user.email ?? user.displayName ?? 'Usuario';
      print('[TOTP] Generando URL QR para: $accountName');
      
      final qrUrl = await totpSecret.generateQrCodeUrl(
        accountName: accountName,
        issuer: 'Yuva',
      );
      
      print('[TOTP] URL QR generada: $qrUrl');

      setState(() {
        _totpSecret = totpSecret.secretKey;
        _qrCodeUrl = qrUrl;
        _qrGenerated = true;
        _isLoading = false;
      });
      
      print('[TOTP] Estado actualizado - QR listo para mostrar');
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('[TOTP ERROR] FirebaseAuthException: ${e.code} - ${e.message}');
      setState(() {
        _errorMessage = 'Error de Firebase: ${e.message ?? e.code}';
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('[TOTP ERROR] Exception: $e');
      print('[TOTP ERROR] StackTrace: $stackTrace');
      setState(() {
        _errorMessage = 'Error al generar código: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyAndEnroll() async {
    if (_codeController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Ingresa el código de 6 dígitos';
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
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Create TOTP assertion with the code
      final session = await user.multiFactor.getSession();
      final totpSecret = await firebase_auth.TotpMultiFactorGenerator.generateSecret(session);
      
      final multiFactorAssertion = await firebase_auth.TotpMultiFactorGenerator.getAssertionForEnrollment(
        totpSecret,
        _codeController.text.trim(),
      );

      // Enroll the TOTP factor
      await user.multiFactor.enroll(
        multiFactorAssertion,
        displayName: 'Authenticator App',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticación de dos factores configurada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
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

  String _mapFirebaseError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'Código incorrecto. Verifica e intenta de nuevo.';
      case 'session-expired':
        return 'La sesión ha expirado. Intenta nuevamente.';
      default:
        return 'Error: ${e.message ?? 'Ocurrió un error inesperado'}';
    }
  }

  void _copySecret() {
    if (_totpSecret != null) {
      Clipboard.setData(ClipboardData(text: _totpSecret!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clave secreta copiada al portapapeles'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Autenticación 2FA'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Usa Google Authenticator, Microsoft Authenticator o cualquier app TOTP compatible.',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            if (_isLoading && !_qrGenerated) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 16),
              const Text(
                'Generando código...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ] else if (_qrGenerated) ...[
              // Step 1: Scan QR
              const Text(
                'Paso 1: Escanea el código QR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Abre tu app de autenticación y escanea este código:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // QR Code
              if (_qrCodeUrl != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _qrCodeUrl!,
                      size: 200,
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Manual entry option
              ExpansionTile(
                title: const Text('¿No puedes escanear? Ingresa manualmente'),
                children: [
                  if (_totpSecret != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              _totpSecret!,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: _copySecret,
                            tooltip: 'Copiar',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Copia esta clave en tu app de autenticación',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 32),

              // Step 2: Enter code
              const Text(
                'Paso 2: Ingresa el código de verificación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ingresa el código de 6 dígitos que aparece en tu app:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Código de Verificación',
                  hintText: '123456',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
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
                autofocus: false,
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Verify button
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyAndEnroll,
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
                        'Verificar y Activar',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],

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
                          '¿Necesitas una app de autenticación?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Descarga una de estas apps:\n'
                      '• Google Authenticator\n'
                      '• Microsoft Authenticator\n'
                      '• Authy\n'
                      '• LastPass Authenticator',
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
