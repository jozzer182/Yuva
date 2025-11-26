import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/models/worker_user.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/avatar_picker.dart';
import 'edit_profile_screen.dart';
import '../../utils/money_formatter.dart';

/// Profile screen for workers
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final workerUser = ref.watch(workerUserProvider);
    final isDummyMode = ref.watch(appSettingsProvider.select((s) => s.isDummyMode));

    if (workerUser == null) {
      return Scaffold(
        backgroundColor: isDark ? YuvaColors.darkBackground : YuvaColors.backgroundLight,
        appBar: AppBar(title: Text(l10n.profile)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? YuvaColors.darkBackground : YuvaColors.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dummy Mode Switch - at the top
            YuvaCard(
              child: SwitchListTile(
                title: Text(l10n.demoMode),
                subtitle: Text(l10n.demoModeDescription),
                value: isDummyMode,
                onChanged: (value) {
                  ref.read(appSettingsProvider.notifier).setDummyMode(value);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Profile header
            YuvaCard(
              child: Column(
                children: [
                  // Avatar display
                  AvatarDisplay(
                    avatarId: workerUser.avatarId,
                    fallbackInitial: workerUser.displayName,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    workerUser.displayName,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workerUser.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: YuvaColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Profile details
            YuvaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileDetailRow(
                    icon: Icons.location_on,
                    label: l10n.baseArea,
                    value: workerUser.cityOrZone,
                  ),
                  const Divider(height: 24),
                  _ProfileDetailRow(
                    icon: Icons.attach_money,
                    label: l10n.baseHourlyRate,
                    value: l10n.perHour('\$${formatAmount(workerUser.baseHourlyRate, context)}'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Edit profile button
            SizedBox(
              width: double.infinity,
              child: YuvaButton(
                text: l10n.editProfile,
                onPressed: () async {
                  final updated = await Navigator.of(context).push<WorkerUser>(
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(initial: workerUser),
                    ),
                  );
                  if (updated != null) {
                    await ref.read(workerUserProvider.notifier).setWorkerUser(updated);
                  }
                },
                buttonStyle: YuvaButtonStyle.secondary,
                icon: Icons.edit,
              ),
            ),

            const SizedBox(height: 12),

            // Security Settings
            YuvaCard(
              child: ListTile(
                leading: const Icon(Icons.security, color: YuvaColors.primaryTeal),
                title: const Text('Seguridad'),
                subtitle: const Text('Autenticación y privacidad'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),

            const SizedBox(height: 12),

            // Language selector
            YuvaCard(
              child: _LanguageSelector(),
            ),

            const SizedBox(height: 24),

            // Logout button
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/auth');
              },
              child: Text(
                l10n.logout,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: YuvaColors.error,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LanguageSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(appSettingsProvider.select((s) => s.localeCode));

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          l10n.language,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        ListTile(
          title: Text(l10n.spanish),
          leading: Radio<String>(
            value: 'es',
            groupValue: currentLocale,
            onChanged: (value) {
              if (value != null) {
                ref.read(appSettingsProvider.notifier).setLocale(value);
              }
            },
          ),
          onTap: () {
            ref.read(appSettingsProvider.notifier).setLocale('es');
          },
          contentPadding: EdgeInsets.zero,
        ),
        ListTile(
          title: Text(l10n.english),
          leading: Radio<String>(
            value: 'en',
            groupValue: currentLocale,
            onChanged: (value) {
              if (value != null) {
                ref.read(appSettingsProvider.notifier).setLocale(value);
              }
            },
          ),
          onTap: () {
            ref.read(appSettingsProvider.notifier).setLocale('en');
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
