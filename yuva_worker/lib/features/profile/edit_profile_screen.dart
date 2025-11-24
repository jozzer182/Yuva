import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../data/models/worker_profile.dart';
import '../../core/providers.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final WorkerProfile initial;

  const EditProfileScreen({super.key, required this.initial});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final parts = widget.initial.displayName.split(' ');
    _firstNameController = TextEditingController(text: parts.isNotEmpty ? parts.first : '');
    _lastNameController = TextEditingController(
      text: parts.length > 1 ? parts.sublist(1).join(' ') : '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    setState(() => _saving = true);
    final repo = ref.read(workerProfileRepositoryProvider);
    final updated = widget.initial.copyWith(
      displayName: '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim(),
    );
    await repo.updateWorkerProfile(updated);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileUpdated)));
    Navigator.of(context).pop<WorkerProfile>(updated);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
