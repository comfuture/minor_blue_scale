import 'package:flutter/material.dart';

import '../models/gender.dart';
import '../models/user_profile.dart';
import '../theme/design_tokens.dart';

class UserCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const UserCard({super.key, required this.user, required this.onTap, this.onDelete});

  IconData get _genderIcon {
    switch (user.gender) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
      case Gender.none:
        return Icons.person;
    }
  }

  Color _bg(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return user.isGuest ? Colors.grey.shade100 : primary.withValues(alpha: 0.08);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _bg(context),
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  child: Icon(_genderIcon),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const Spacer(),
            Text(
              user.nickname,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              user.isGuest
                  ? '게스트'
                  : '${user.age}세 · ${user.heightCm.toStringAsFixed(0)}cm',
              style: const TextStyle(color: Colors.black54),
            ),
            if (user.targetWeight != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(Icons.flag, size: 16, color: Colors.grey.shade700),
                    const SizedBox(width: 4),
                    Text('목표 ${user.targetWeight!.toStringAsFixed(1)} kg'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
