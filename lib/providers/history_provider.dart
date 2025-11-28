import 'package:flutter/material.dart';

import '../models/weight_entry.dart';
import '../services/local_storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  final LocalStorageService storage;
  List<WeightEntry> entries = [];
  bool loading = false;

  HistoryProvider(this.storage);

  Future<void> load(String userId) async {
    loading = true;
    notifyListeners();
    entries = storage.getWeights(userId);
    loading = false;
    notifyListeners();
  }

  Future<void> add(WeightEntry entry) async {
    entries = [...entries, entry];
    await storage.addWeight(entry);
    notifyListeners();
  }

  Future<void> remove(String entryId, String userId) async {
    entries = entries.where((e) => e.id != entryId).toList();
    await storage.removeWeight(userId: userId, entryId: entryId);
    notifyListeners();
  }
}
