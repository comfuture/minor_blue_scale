import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_profile.dart';
import '../models/weight_entry.dart';

class LocalStorageService {
  static const _userBoxName = 'users';
  static const _weightBoxName = 'weights';
  static const _prefsBoxName = 'prefs';

  late Box _userBox;
  late Box _weightBox;
  late Box _prefsBox;

  Future<void> init() async {
    _userBox = await Hive.openBox(_userBoxName);
    _weightBox = await Hive.openBox(_weightBoxName);
    _prefsBox = await Hive.openBox(_prefsBoxName);
  }

  // ----- Users -----
  Future<void> upsertUser(UserProfile user) async {
    await _userBox.put(user.id, user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
    await _weightBox.delete(id);
  }

  List<UserProfile> getUsers() {
    return _userBox.values
        .map((e) => UserProfile.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // ----- Selection -----
  Future<void> setLastUserId(String? id) async {
    if (id == null) {
      await _prefsBox.delete('lastUserId');
    } else {
      await _prefsBox.put('lastUserId', id);
    }
  }

  String? getLastUserId() => _prefsBox.get('lastUserId') as String?;

  // ----- Weights -----
  List<WeightEntry> getWeights(String userId) {
    final raw = _weightBox.get(userId, defaultValue: []) as List;
    return raw
        .map((e) => WeightEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  }

  Future<void> addWeight(WeightEntry entry) async {
    final list = List<Map<String, dynamic>>.from(
      _weightBox.get(entry.userId, defaultValue: []),
    );
    list.add(entry.toJson());
    await _weightBox.put(entry.userId, list);
  }
}
