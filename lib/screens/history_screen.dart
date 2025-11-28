import 'package:flutter/material.dart';
import 'package:minor_blue_scale/l10n/app_localizations.dart';

import '../models/user_profile.dart';
import 'history_view.dart';

class HistoryScreen extends StatelessWidget {
  final UserProfile user;
  const HistoryScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: SafeArea(
        top: false,
        bottom: true,
        child: HistoryView(user: user),
      ),
    );
  }
}
