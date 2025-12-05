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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.featureComingSoon),
                      behavior: SnackBarBehavior.floating,
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

              // Delete Account Button
              _DeleteAccountButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openFeedbackForm(BuildContext context, AppLocalizations l10n) async {
    await _openUrl(context, l10n, 'https://forms.gle/52gzoNH6dmX6zRp49');
  }

  Future<void> _openUrl(BuildContext context, AppLocalizations l10n, String url) async {
    final uri = Uri.parse(url);
    
    try {
      // Try to open in external browser
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        // If couldn't launch, copy to clipboard
        await Clipboard.setData(ClipboardData(text: url));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.linkCopied)),
          );
        }
      }
    } catch (e) {
      // On error, copy to clipboard
      await Clipboard.setData(ClipboardData(text: url));
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

/// Delete Account Button with confirmation dialogs
class _DeleteAccountButton extends ConsumerStatefulWidget {
  @override
  ConsumerState<_DeleteAccountButton> createState() => _DeleteAccountButtonState();
}

class _DeleteAccountButtonState extends ConsumerState<_DeleteAccountButton> {
  bool _isDeleting = false;

  Future<void> _handleDeleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    
    // First confirmation dialog
    final firstConfirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.deleteAccountConfirmTitle)),
          ],
        ),
        content: Text(l10n.deleteAccountConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.deleteAccountButton),
          ),
        ],
      ),
    );

    if (firstConfirm != true || !mounted) return;

    // Second confirmation dialog with countdown
    final secondConfirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CountdownConfirmDialog(
        title: l10n.deleteAccountFinalConfirmTitle,
        getMessage: (seconds) => l10n.deleteAccountFinalConfirmMessage(seconds),
        cancelText: l10n.cancel,
        confirmText: l10n.deleteAccountButton,
        countdownSeconds: 8,
      ),
    );

    if (secondConfirm != true || !mounted) return;

    // Proceed with account deletion
    setState(() => _isDeleting = true);

    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      ref.read(currentUserProvider.notifier).state = null;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteAccountSuccess),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.deleteAccountError}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return TextButton.icon(
      onPressed: _isDeleting ? null : _handleDeleteAccount,
      icon: _isDeleting 
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.red,
              ),
            )
          : Icon(Icons.delete_forever_rounded, color: Colors.red),
      label: Text(
        l10n.deleteAccount,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

/// Countdown confirmation dialog
class _CountdownConfirmDialog extends StatefulWidget {
  final String title;
  final String Function(int seconds) getMessage;
  final String cancelText;
  final String confirmText;
  final int countdownSeconds;

  const _CountdownConfirmDialog({
    required this.title,
    required this.getMessage,
    required this.cancelText,
    required this.confirmText,
    required this.countdownSeconds,
  });

  @override
  State<_CountdownConfirmDialog> createState() => _CountdownConfirmDialogState();
}

class _CountdownConfirmDialogState extends State<_CountdownConfirmDialog> {
  late int _remainingSeconds;
  bool _canConfirm = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.countdownSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _canConfirm = true;
        }
      });

      if (_remainingSeconds > 0) {
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.timer, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(widget.title)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.getMessage(_remainingSeconds)),
          const SizedBox(height: 16),
          if (!_canConfirm)
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _remainingSeconds / widget.countdownSeconds,
                    strokeWidth: 4,
                    color: Colors.red,
                    backgroundColor: Colors.red.withValues(alpha: 0.2),
                  ),
                  Text(
                    '$_remainingSeconds',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(widget.cancelText),
        ),
        ElevatedButton(
          onPressed: _canConfirm ? () => Navigator.of(context).pop(true) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
