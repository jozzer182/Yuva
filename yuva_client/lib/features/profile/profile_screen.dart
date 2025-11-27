import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/avatar_picker.dart';
import '../../design_system/typography.dart';
import '../../design_system/colors.dart';
import '../../core/providers.dart';
import 'package:yuva/l10n/app_localizations.dart';
import 'edit_profile_screen.dart';
import '../ratings/my_reviews_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(appSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YuvaScaffold(
      useGradientBackground: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Help Us Improve Section - at the top for visibility
              YuvaCard(
                onTap: () => _openFeedbackForm(context, l10n),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTealLight)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.feedback_outlined,
                        color: YuvaColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.helpUsImprove, style: YuvaTypography.subtitle()),
                          const SizedBox(height: 4),
                          Text(
                            l10n.helpUsImproveDescription,
                            style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.open_in_new_rounded,
                      color: YuvaColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // User Profile Card
              YuvaCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: 'user_avatar',
                          child: AvatarDisplay(
                            avatarId: user?.avatarId,
                            fallbackInitial: user?.name ?? 'U',
                            size: 72,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Guest',
                                style: YuvaTypography.title(),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? '',
                                style: YuvaTypography.body(color: YuvaColors.textSecondary),
                              ),
                              if (user?.phone != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  user!.phone!,
                                  style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    YuvaButton(
                      text: l10n.editProfile,
                      icon: Icons.edit_outlined,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                      buttonStyle: YuvaButtonStyle.secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // My Reviews Section
              YuvaCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MyReviewsScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTealLight)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.amber.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.myReviews, style: YuvaTypography.subtitle()),
                          const SizedBox(height: 4),
                          Text(
                            l10n.myReviewsSubtitle,
                            style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: YuvaColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Settings Section Title
              Text(
                l10n.settings,
                style: YuvaTypography.sectionTitle(),
              ),
              const SizedBox(height: 12),

              // Language Settings
              YuvaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.language_rounded, color: YuvaColors.primaryTeal, size: 20),
                        const SizedBox(width: 12),
                        Text(l10n.language, style: YuvaTypography.subtitle()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _LanguageOption(
                      label: l10n.spanish,
                      code: 'es',
                      isSelected: settings.localeCode == 'es',
                      onTap: () {
                        ref.read(appSettingsProvider.notifier).setLocale('es');
                      },
                    ),
                    const SizedBox(height: 8),
                    _LanguageOption(
                      label: l10n.english,
                      code: 'en',
                      isSelected: settings.localeCode == 'en',
                      onTap: () {
                        ref.read(appSettingsProvider.notifier).setLocale('en');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Security Settings
              YuvaCard(
                child: ListTile(
                  leading: const Icon(Icons.security, color: YuvaColors.primaryTeal),
                  title: Text('Seguridad', style: YuvaTypography.subtitle()),
                  subtitle: const Text('Autenticación y privacidad'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Notification Settings
              YuvaCard(
                child: Column(
                  children: [
                    _SettingToggle(
                      icon: Icons.notifications_outlined,
                      title: l10n.notifications,
                      subtitle: l10n.notificationsSubtitle,
                      value: settings.notificationsEnabled,
                      onChanged: (value) {
                        ref.read(appSettingsProvider.notifier).toggleNotifications(value);
                      },
                    ),
                    const Divider(height: 24),
                    _SettingToggle(
                      icon: Icons.campaign_outlined,
                      title: l10n.marketingOptIn,
                      subtitle: l10n.marketingSubtitle,
                      value: settings.marketingOptIn,
                      onChanged: (value) {
                        ref.read(appSettingsProvider.notifier).toggleMarketingOptIn(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dummy Mode Switch - at the bottom before logout
              YuvaCard(
                child: SwitchListTile(
                  title: Text(l10n.demoMode),
                  subtitle: Text(l10n.demoModeDescription),
                  value: settings.isDummyMode,
                  onChanged: (value) async {
                    if (value) {
                      // Show warning dialog when trying to enable dummy mode
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: YuvaColors.warning),
                              const SizedBox(width: 8),
                              Expanded(child: Text(l10n.demoModeWarningTitle)),
                            ],
                          ),
                          content: Text(l10n.demoModeWarningMessage),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(l10n.cancel),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: YuvaColors.warning,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(l10n.enableDemoMode),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        ref.read(appSettingsProvider.notifier).setDummyMode(true);
                      }
                    } else {
                      ref.read(appSettingsProvider.notifier).setDummyMode(false);
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              YuvaButton(
                text: l10n.logout,
                icon: Icons.logout_rounded,
                onPressed: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  ref.read(currentUserProvider.notifier).state = null;
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
                  }
                },
                buttonStyle: YuvaButtonStyle.ghost,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openFeedbackForm(BuildContext context, AppLocalizations l10n) async {
    const feedbackUrl = 'https://forms.gle/52gzoNH6dmX6zRp49';
    final uri = Uri.parse(feedbackUrl);
    
    try {
      // Try to open in external browser
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        // If couldn't launch, copy to clipboard
        await Clipboard.setData(const ClipboardData(text: feedbackUrl));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.linkCopied)),
          );
        }
      }
    } catch (e) {
      // On error, copy to clipboard
      await Clipboard.setData(const ClipboardData(text: feedbackUrl));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.linkCopied)),
        );
      }
    }
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal)
                  .withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? YuvaColors.primaryTeal
                      : YuvaColors.textSecondary.withValues(alpha: 0.4),
                  width: 2,
                ),
                color: isSelected ? YuvaColors.primaryTeal : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: YuvaTypography.body(
                color: isSelected ? YuvaColors.primaryTealDark : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: YuvaColors.primaryTeal, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: YuvaTypography.subtitle()),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: YuvaTypography.caption(color: YuvaColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: YuvaColors.primaryTeal.withValues(alpha: 0.5),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return YuvaColors.primaryTeal;
            }
            return null;
          }),
        ),
      ],
    );
  }
}
