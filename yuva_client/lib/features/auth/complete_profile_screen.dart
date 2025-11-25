import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../core/providers.dart';
import '../../data/models/user.dart';
import 'package:yuva/l10n/app_localizations.dart';

/// Screen to complete client profile after Google sign-in.
/// Collects required fields: phone number.
class CompleteProfileScreen extends ConsumerStatefulWidget {
  final User authUser;

  const CompleteProfileScreen({super.key, required this.authUser});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.authUser.name);
    _phoneController = TextEditingController(text: widget.authUser.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final displayName = _nameController.text.trim();
      final phone = _phoneController.text.trim();

      // Update displayName in Firebase Auth if changed
      final firebaseAuth = ref.read(firebaseAuthProvider);
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null && displayName != widget.authUser.name) {
        await currentUser.updateDisplayName(displayName);
        await currentUser.reload();
      }

      // Create updated User with completed profile
      final updatedUser = widget.authUser.copyWith(
        name: displayName,
        phone: phone,
      );

      // Save to state
      ref.read(currentUserProvider.notifier).state = updatedUser;

      if (!mounted) return;

      // Navigate to main screen
      Navigator.of(context).pushReplacementNamed('/main');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    final l10n = AppLocalizations.of(context)!;
    // Show confirmation dialog before going back
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.completeProfileExitTitle),
        content: Text(l10n.completeProfileExitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              // Sign out and go back to login
              await ref.read(authRepositoryProvider).signOut();
              ref.read(currentUserProvider.notifier).state = null;
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
    
    if (shouldPop == true && mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onWillPop();
        }
      },
      child: Scaffold(
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Header
                    Text(
                      l10n.completeProfileTitle,
                      style: YuvaTypography.hero(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.completeProfileSubtitleClient,
                      style: YuvaTypography.body(color: YuvaColors.textSecondary),
                    ),
                    const SizedBox(height: 32),

                    // Profile photo and email (pre-filled from Google)
                    if (widget.authUser.photoUrl != null) ...[
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(widget.authUser.photoUrl!),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Center(
                      child: Text(
                        widget.authUser.email,
                        style: YuvaTypography.body(color: YuvaColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form fields
                    YuvaCard(
                      child: Column(
                        children: [
                          // Name field (pre-filled)
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: l10n.name,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.completeProfileNameRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Phone field (required for clients)
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: l10n.completeProfilePhone,
                              hintText: l10n.completeProfilePhoneHint,
                              prefixIcon: const Icon(Icons.phone_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.completeProfilePhoneRequired;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: YuvaButton(
                        text: l10n.completeProfileSave,
                        onPressed: _isSaving ? null : _saveProfile,
                        isLoading: _isSaving,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
