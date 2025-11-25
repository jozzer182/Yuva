import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final String localeCode;
  final bool notificationsEnabled;
  final bool marketingOptIn;
  final bool isDummyMode; // Dummy mode for sample data

  const AppSettings({
    this.localeCode = 'es',
    this.notificationsEnabled = true,
    this.marketingOptIn = false,
    this.isDummyMode = true, // Default ON for first run
  });

  AppSettings copyWith({
    String? localeCode,
    bool? notificationsEnabled,
    bool? marketingOptIn,
    bool? isDummyMode,
  }) {
    return AppSettings(
      localeCode: localeCode ?? this.localeCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      marketingOptIn: marketingOptIn ?? this.marketingOptIn,
      isDummyMode: isDummyMode ?? this.isDummyMode,
    );
  }
}

/// Simple controller to hold user preferences locally.
/// Uses SharedPreferences behind the scenes so the locale persists.
class AppSettingsController extends StateNotifier<AppSettings> {
  AppSettingsController({SharedPreferences? preferences})
      : _preferences = preferences,
        super(const AppSettings()) {
    unawaited(_restore());
  }

  final SharedPreferences? _preferences;

  static const _localeKey = 'yuva_locale';
  static const _notificationsKey = 'yuva_notifications';
  static const _marketingKey = 'yuva_marketing';
  static const _dummyModeKey = 'yuva_dummy_mode';

  Future<void> _restore() async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      // Check if dummy mode has been set before (if not, default to true for first run)
      final dummyModeSet = prefs.containsKey(_dummyModeKey);
      state = state.copyWith(
        localeCode: prefs.getString(_localeKey) ?? state.localeCode,
        notificationsEnabled: prefs.getBool(_notificationsKey) ?? state.notificationsEnabled,
        marketingOptIn: prefs.getBool(_marketingKey) ?? state.marketingOptIn,
        isDummyMode: dummyModeSet ? (prefs.getBool(_dummyModeKey) ?? true) : true,
      );
    } catch (_) {
      // Default in-memory state is good enough if persistence fails.
    }
  }

  Future<void> setLocale(String localeCode) async {
    state = state.copyWith(localeCode: localeCode);
    await _persist((prefs) => prefs.setString(_localeKey, localeCode));
  }

  Future<void> toggleNotifications(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _persist((prefs) => prefs.setBool(_notificationsKey, enabled));
  }

  Future<void> toggleMarketingOptIn(bool enabled) async {
    state = state.copyWith(marketingOptIn: enabled);
    await _persist((prefs) => prefs.setBool(_marketingKey, enabled));
  }

  Future<void> setDummyMode(bool enabled) async {
    state = state.copyWith(isDummyMode: enabled);
    await _persist((prefs) => prefs.setBool(_dummyModeKey, enabled));
  }

  Future<void> _persist(Future<bool> Function(SharedPreferences prefs) action) async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      await action(prefs);
    } catch (_) {
      // Ignore persistence errors for now (Phase 3 is local-only).
    }
  }
}
