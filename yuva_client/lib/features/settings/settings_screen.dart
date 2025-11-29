import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/providers.dart';

/// Pantalla de ajustes con opciones de seguridad
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader('Cuenta'),
          if (currentUser != null) ...[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: currentUser.photoUrl != null
                    ? NetworkImage(currentUser.photoUrl!)
                    : null,
                child: currentUser.photoUrl == null
                    ? Text(currentUser.name[0].toUpperCase())
                    : null,
              ),
              title: Text(currentUser.name),
              subtitle: Text(currentUser.email),
            ),
            const Divider(),
          ],

          // Security Section
          _buildSectionHeader('Seguridad'),
          
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Cambiar Contraseña'),
            subtitle: const Text('Actualiza tu contraseña de acceso'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePasswordDialog(context),
          ),
          const Divider(),

          // Privacy Section
          _buildSectionHeader('Privacidad'),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Política de Privacidad'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openUrl(context, 'https://github.com/jozzer182/Yuva/blob/main/PRIVACY_POLICY.md'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Términos y Condiciones'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openUrl(context, 'https://github.com/jozzer182/Yuva/blob/main/TERMS_AND_CONDITIONS.md'),
          ),
          const Divider(),

          // App Section
          _buildSectionHeader('Aplicación'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de'),
            subtitle: const Text('Versión 1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Yuva Client',
                applicationVersion: '1.0.0',
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'icons/Android/Icon-96.png',
                    width: 64,
                    height: 64,
                  ),
                ),
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Desarrollado por José Zarabanda',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Text('Noviembre 2025'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _openUrl(context, 'https://zarabanda-dev.web.app/'),
                    child: const Text(
                      'zarabanda-dev.web.app',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cambiar Contraseña'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: 'Nueva contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(obscureNewPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => obscureNewPassword = !obscureNewPassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa la nueva contraseña';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                      ),
                    ),
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            throw Exception('Usuario no autenticado');
                          }

                          // Update password
                          await user.updatePassword(newPasswordController.text);

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Contraseña actualizada correctamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() => isLoading = false);
                          String message;
                          switch (e.code) {
                            case 'weak-password':
                              message = 'La contraseña es muy débil';
                              break;
                            case 'requires-recent-login':
                              message = 'Por seguridad, cierra sesión y vuelve a iniciar';
                              break;
                            default:
                              message = 'Error: ${e.message}';
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message), backgroundColor: Colors.red),
                            );
                          }
                        } catch (e) {
                          setState(() => isLoading = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                            );
                          }
                        }
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Cambiar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: url));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enlace copiado al portapapeles')),
          );
        }
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: url));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enlace copiado al portapapeles')),
        );
      }
    }
  }

}
