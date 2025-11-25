import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/worker_user.dart';
import '../data/models/user.dart';

/// Controller to manage WorkerUser state (stored in SharedPreferences)
class WorkerUserController extends StateNotifier<WorkerUser?> {
  WorkerUserController() : super(null) {
    _loadWorkerUser();
  }

  static const _keyPrefix = 'worker_user_';

  Future<void> _loadWorkerUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('${_keyPrefix}uid');
      final displayName = prefs.getString('${_keyPrefix}displayName');
      final email = prefs.getString('${_keyPrefix}email');
      final photoUrl = prefs.getString('${_keyPrefix}photoUrl');
      final phone = prefs.getString('${_keyPrefix}phone');
      final createdAtMs = prefs.getInt('${_keyPrefix}createdAt');
      final cityOrZone = prefs.getString('${_keyPrefix}cityOrZone') ?? 'No especificado';
      final baseHourlyRate = prefs.getDouble('${_keyPrefix}baseHourlyRate') ?? 0.0;

      if (uid != null && displayName != null && email != null && createdAtMs != null) {
        state = WorkerUser(
          uid: uid,
          displayName: displayName,
          email: email,
          photoUrl: photoUrl,
          phone: phone,
          createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
          cityOrZone: cityOrZone,
          baseHourlyRate: baseHourlyRate,
        );
      }
    } catch (_) {
      // Keep state as null if loading fails
    }
  }

  Future<void> setWorkerUser(WorkerUser workerUser) async {
    state = workerUser;
    await _saveWorkerUser(workerUser);
  }

  Future<void> _saveWorkerUser(WorkerUser workerUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_keyPrefix}uid', workerUser.uid);
      await prefs.setString('${_keyPrefix}displayName', workerUser.displayName);
      await prefs.setString('${_keyPrefix}email', workerUser.email);
      if (workerUser.photoUrl != null) {
        await prefs.setString('${_keyPrefix}photoUrl', workerUser.photoUrl!);
      }
      if (workerUser.phone != null) {
        await prefs.setString('${_keyPrefix}phone', workerUser.phone!);
      }
      await prefs.setInt('${_keyPrefix}createdAt', workerUser.createdAt.millisecondsSinceEpoch);
      await prefs.setString('${_keyPrefix}cityOrZone', workerUser.cityOrZone);
      await prefs.setDouble('${_keyPrefix}baseHourlyRate', workerUser.baseHourlyRate);
    } catch (_) {
      // Ignore persistence errors
    }
  }

  Future<void> updateFromAuthUser(User authUser) async {
    if (state != null) {
      // Update auth fields but keep worker-specific fields
      final updated = state!.copyWith(
        displayName: authUser.name,
        email: authUser.email,
        photoUrl: authUser.photoUrl,
        phone: authUser.phone,
      );
      await setWorkerUser(updated);
    }
  }

  Future<void> clear() async {
    state = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_keyPrefix}uid');
      await prefs.remove('${_keyPrefix}displayName');
      await prefs.remove('${_keyPrefix}email');
      await prefs.remove('${_keyPrefix}photoUrl');
      await prefs.remove('${_keyPrefix}phone');
      await prefs.remove('${_keyPrefix}createdAt');
      await prefs.remove('${_keyPrefix}cityOrZone');
      await prefs.remove('${_keyPrefix}baseHourlyRate');
    } catch (_) {
      // Ignore errors
    }
  }
}

