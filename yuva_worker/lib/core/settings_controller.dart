import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App settings model
class AppSettings {
  final String localeCode;
  final bool notificationsEnabled;
  final bool isDummyMode; // Dummy mode for sample data

  const AppSettings({
    this.localeCode = 'es', // Spanish as default
    this.notificationsEnabled = true,
    this.isDummyMode = true, // Default ON for first run
  });

  AppSettings copyWith({
    String? localeCode,
    bool? notificationsEnabled,
    bool? isDummyMode,
  }) {
    return AppSettings(
      localeCode: localeCode ?? this.localeCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isDummyMode: isDummyMode ?? this.isDummyMode,
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
  static const _dummyModeKey = 'dummy_mode';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Check if dummy mode has been set before (if not, default to true for first run)
    final dummyModeSet = prefs.containsKey(_dummyModeKey);
    state = AppSettings(
      localeCode: prefs.getString(_localeKey) ?? 'es',
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      isDummyMode: dummyModeSet ? (prefs.getBool(_dummyModeKey) ?? true) : true,
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

  Future<void> setDummyMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dummyModeKey, enabled);
    state = state.copyWith(isDummyMode: enabled);
  }
}
