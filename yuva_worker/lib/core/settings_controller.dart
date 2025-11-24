import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App settings model
class AppSettings {
  final String localeCode;
  final bool notificationsEnabled;

  const AppSettings({
    this.localeCode = 'es', // Spanish as default
    this.notificationsEnabled = true,
  });

  AppSettings copyWith({
    String? localeCode,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      localeCode: localeCode ?? this.localeCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

/// Settings controller
class AppSettingsController extends StateNotifier<AppSettings> {
  AppSettingsController() : super(const AppSettings()) {
    _loadSettings();
  }

  static const _localeKey = 'locale_code';
  static const _notificationsKey = 'notifications_enabled';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      localeCode: prefs.getString(_localeKey) ?? 'es',
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
    );
  }

  Future<void> setLocale(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, localeCode);
    state = state.copyWith(localeCode: localeCode);
  }

  Future<void> setNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }
}
