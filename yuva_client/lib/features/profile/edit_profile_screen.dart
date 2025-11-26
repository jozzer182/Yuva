import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/components/avatar_picker.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedAvatarId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _selectedAvatarId = user?.avatarId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.editProfileTitle, style: YuvaTypography.subtitle()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar picker
              Center(
                child: AvatarPicker(
                  selectedAvatarId: _selectedAvatarId,
                  fallbackInitial: _nameController.text,
                  onAvatarSelected: (avatarId) {
                    setState(() => _selectedAvatarId = avatarId);
                  },
                ),
              ),
              const SizedBox(height: 24),
              YuvaCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              YuvaButton(
                text: l10n.saveChanges,
                isLoading: _isSaving,
                onPressed: _isSaving ? null : _saveProfile,
              ),
              const SizedBox(height: 12),
              YuvaButton(
                text: l10n.cancel,
                onPressed: () => Navigator.of(context).pop(),
                buttonStyle: YuvaButtonStyle.ghost,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isSaving = true;
    });

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        final displayName = _nameController.text.trim();
        final phone = _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim();
        
        // Update displayName in Firebase Auth if changed
        final firebaseAuth = ref.read(firebaseAuthProvider);
        final authUser = firebaseAuth.currentUser;
        if (authUser != null && displayName != currentUser.name) {
          await authUser.updateDisplayName(displayName);
          await authUser.reload();
        }

        final updatedUser = currentUser.copyWith(
          name: displayName,
          email: _emailController.text.trim(),
          phone: phone,
          avatarId: _selectedAvatarId,
        );

        // Save to Firestore
        final userProfileService = ref.read(userProfileServiceProvider);
        await userProfileService.saveUserProfile(
          uid: updatedUser.id,
          displayName: displayName,
          email: updatedUser.email,
          photoUrl: updatedUser.photoUrl,
          phone: phone,
          avatarId: _selectedAvatarId,
          createdAt: updatedUser.createdAt,
        );

        // Update local state
        ref.read(currentUserProvider.notifier).state = updatedUser;
      }

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdated),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
