import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/components/yuva_button.dart';
import '../../core/responsive.dart';
import 'package:yuva/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'No existe una cuenta con este correo';
            break;
          case 'invalid-email':
            message = 'El correo no es válido';
            break;
          default:
            message = 'Error: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : YuvaColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
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
                child: _emailSent ? _buildSuccessView(l10n, isDark) : _buildFormView(l10n, isDark),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView(AppLocalizations l10n, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.lock_reset,
            size: 64,
            color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.forgotPassword,
            style: YuvaTypography.hero(),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.forgotPasswordDescription,
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
                return l10n.emailRequired;
              }
              if (!value.contains('@')) {
                return l10n.emailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: YuvaButton(
              text: l10n.sendResetLink,
              onPressed: _isLoading ? null : _handleResetPassword,
              isLoading: _isLoading,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.backToLogin,
                style: YuvaTypography.body(
                  color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.mark_email_read,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.resetEmailSent,
          style: YuvaTypography.hero(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.resetEmailSentDescription(_emailController.text),
          style: YuvaTypography.body(color: YuvaColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: YuvaButton(
            text: l10n.backToLogin,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: Text(
            l10n.sendAgain,
            style: YuvaTypography.body(
              color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
            ),
          ),
        ),
      ],
    );
  }
}
