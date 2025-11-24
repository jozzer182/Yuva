import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/models/worker_profile.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import 'edit_profile_screen.dart';
import '../../utils/money_formatter.dart';

/// Profile screen for workers
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

// money formatting moved to utils/money_formatter.dart

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  WorkerProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final repo = ref.read(workerProfileRepositoryProvider);
    final profile = await repo.getCurrentWorker();

    if (mounted) {
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
      ref.read(currentWorkerProvider.notifier).state = profile;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YuvaColors.darkBackground : YuvaColors.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile header
                  YuvaCard(
                    child: Column(
                      children: [
                        // Avatar placeholder
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: YuvaColors.primaryTeal,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              _profile!.displayName.substring(0, 1).toUpperCase(),
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _profile!.displayName,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 8),
                        if (_profile!.ratingCount > 0)
                          Text(
                            l10n.rating(
                              _profile!.ratingAverage.toStringAsFixed(1),
                              _profile!.ratingCount,
                            ),
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
                      crossAxisAlignment: .start,
                      children: [
                        _ProfileDetailRow(
                          icon: Icons.location_on,
                          label: l10n.baseArea,
                          value: _profile!.areaBaseLabel,
                        ),
                        const Divider(height: 24),
                        _ProfileDetailRow(
                          icon: Icons.attach_money,
                          label: l10n.baseHourlyRate,
                          value: l10n.perHour('\$${formatAmount(_profile!.baseHourlyRate, context)}'),
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
                        final updated = await Navigator.of(context).push<WorkerProfile>(
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(initial: _profile!),
                          ),
                        );
                        if (updated != null && mounted) {
                          setState(() {
                            _profile = updated;
                          });
                          ref.read(currentWorkerProvider.notifier).state = updated;
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
