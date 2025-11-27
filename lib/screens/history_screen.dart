import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import 'history_view.dart';

class HistoryScreen extends StatelessWidget {
  final UserProfile user;
  const HistoryScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이력')),
      body: HistoryView(user: user),
    );
  }
}
