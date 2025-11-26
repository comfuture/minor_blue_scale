import 'package:flutter/material.dart';

import '../models/gender.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';
import '../utils/id.dart';

class UserProvider extends ChangeNotifier {
  final LocalStorageService storage;

  List<UserProfile> users = [];
  UserProfile? selectedUser;
  bool loaded = false;

  UserProvider(this.storage) {
    _init();
  }

  Future<void> _init() async {
    users = storage.getUsers();
    final lastId = storage.getLastUserId();
    selectedUser = _findById(lastId) ?? users.firstOrNull;
    loaded = true;
    notifyListeners();
  }

  UserProfile? _findById(String? id) {
    if (id == null) return null;
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addUser({
    required String nickname,
    required Gender gender,
    required int age,
    required double heightCm,
    double? targetWeight,
  }) async {
    final user = UserProfile(
      id: generateId(),
      nickname: nickname,
      gender: gender,
      age: age,
      heightCm: heightCm,
      targetWeight: targetWeight,
    );
    users = [...users, user];
    await storage.upsertUser(user);
    await selectUser(user);
  }

  Future<void> updateUser(UserProfile user) async {
    users = users.map((e) => e.id == user.id ? user : e).toList();
    await storage.upsertUser(user);
    notifyListeners();
  }

  Future<void> removeUser(UserProfile user) async {
    users = users.where((u) => u.id != user.id).toList();
    if (selectedUser?.id == user.id) {
      selectedUser = users.firstOrNull;
      await storage.setLastUserId(selectedUser?.id);
    }
    await storage.deleteUser(user.id);
    notifyListeners();
  }

  Future<void> selectUser(UserProfile user) async {
    selectedUser = user;
    if (user.isGuest) {
      await storage.setLastUserId(null);
    } else {
      await storage.setLastUserId(user.id);
    }
    notifyListeners();
  }

  Future<void> selectGuest() async {
    selectedUser = UserProfile.guest();
    await storage.setLastUserId(null);
    notifyListeners();
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
