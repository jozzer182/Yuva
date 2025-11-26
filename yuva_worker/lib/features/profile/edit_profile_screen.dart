import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../data/models/worker_user.dart';
import '../../core/providers.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/avatar_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final WorkerUser initial;

  const EditProfileScreen({super.key, required this.initial});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _cityOrZoneController;
  late TextEditingController _baseHourlyRateController;
  String? _selectedAvatarId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final parts = widget.initial.displayName.split(' ');
    _firstNameController = TextEditingController(text: parts.isNotEmpty ? parts.first : '');
    _lastNameController = TextEditingController(
      text: parts.length > 1 ? parts.sublist(1).join(' ') : '',
    );
    _cityOrZoneController = TextEditingController(text: widget.initial.cityOrZone);
    _baseHourlyRateController = TextEditingController(
      text: widget.initial.baseHourlyRate > 0 
          ? widget.initial.baseHourlyRate.toStringAsFixed(0)
          : '',
    );
    _selectedAvatarId = widget.initial.avatarId;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityOrZoneController.dispose();
    _baseHourlyRateController.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    setState(() => _saving = true);
    
    try {
      final newDisplayName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
      final newCityOrZone = _cityOrZoneController.text.trim();
      final baseHourlyRateText = _baseHourlyRateController.text.trim();
      final newBaseHourlyRate = double.tryParse(baseHourlyRateText) ?? 0.0;
      
      // Update displayName in Firebase Auth
      final firebaseAuth = ref.read(firebaseAuthProvider);
      final currentUser = firebaseAuth.currentUser;
      
      if (currentUser != null && newDisplayName.isNotEmpty) {
        await currentUser.updateDisplayName(newDisplayName);
        await currentUser.reload();
      }
      
      // Update WorkerUser
      final updated = widget.initial.copyWith(
        displayName: newDisplayName,
        cityOrZone: newCityOrZone.isEmpty ? 'No especificado' : newCityOrZone,
        baseHourlyRate: newBaseHourlyRate,
        avatarId: _selectedAvatarId,
      );
      
      // Save to Firestore
      final userProfileService = ref.read(userProfileServiceProvider);
      await userProfileService.saveWorkerProfile(
        uid: updated.uid,
        displayName: newDisplayName,
        email: updated.email,
        photoUrl: updated.photoUrl,
        phone: updated.phone,
        avatarId: _selectedAvatarId,
        createdAt: updated.createdAt,
        cityOrZone: updated.cityOrZone,
        baseHourlyRate: newBaseHourlyRate,
      );
      
      // Save to local state (SharedPreferences)
      await ref.read(workerUserProvider.notifier).setWorkerUser(updated);
      
      if (!mounted) return;
      
      // Refresh auth state to reflect changes
      ref.invalidate(authStateProvider);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileUpdated)),
      );
      Navigator.of(context).pop<WorkerUser>(updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar perfil: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar picker
            AvatarPicker(
              selectedAvatarId: _selectedAvatarId,
              fallbackInitial: widget.initial.displayName,
              onAvatarSelected: (avatarId) {
                setState(() => _selectedAvatarId = avatarId);
              },
            ),
            const SizedBox(height: 24),
            YuvaCard(
              child: Column(
                children: [
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: l10n.name),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: l10n.lastName),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _cityOrZoneController,
                    decoration: InputDecoration(
                      labelText: l10n.cityOrZone,
                      hintText: l10n.cityOrZoneHint,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _baseHourlyRateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.baseHourlyRate,
                      hintText: 'Ej: 45000',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: YuvaButton(
                text: l10n.saveChanges,
                onPressed: _saving ? null : () => _save(l10n),
                isLoading: _saving,
                buttonStyle: YuvaButtonStyle.secondary,
                icon: Icons.save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
