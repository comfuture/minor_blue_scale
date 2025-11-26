import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gender.dart';
import '../providers/user_provider.dart';
import '../theme/design_tokens.dart';
import '../widgets/user_card.dart';
import 'home_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  final bool isFirstLaunch;
  const UserSelectionScreen({super.key, this.isFirstLaunch = false});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _targetController = TextEditingController();
  Gender _gender = Gender.none;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('새 사용자 추가',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '닉네임'),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: Gender.values
                      .map(
                        (g) => ChoiceChip(
                          label: Text(g.label),
                          selected: _gender == g,
                          onSelected: (_) => setState(() => _gender = g),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '나이'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '키 (cm)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '목표 체중 (선택)'),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitUser,
                    child: const Text('등록'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitUser() async {
    final navigator = Navigator.of(context);
    final isFirst = widget.isFirstLaunch;
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final height = double.tryParse(_heightController.text.trim());
    final target = double.tryParse(_targetController.text.trim());

    if (name.isEmpty || age == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임, 나이, 키를 모두 입력해주세요.')),
      );
      return;
    }

    await context.read<UserProvider>().addUser(
          nickname: name,
          gender: _gender,
          age: age,
          heightCm: height,
          targetWeight: target,
        );
    if (!context.mounted) return;
    navigator.pop(); // close sheet
    if (isFirst) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      navigator.pop(); // close selection screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final users = userProvider.users;

    return Scaffold(
      appBar: widget.isFirstLaunch
          ? null
          : AppBar(
              title: const Text('사용자 선택'),
            ),
      body: Padding(
        padding: DesignTokens.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '누구의 체중을 관리할까요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text('마지막 선택 사용자는 자동으로 불러와져요.'),
            const SizedBox(height: 18),
            Expanded(
              child: users.isEmpty
                  ? _EmptyState(onAdd: _openAddSheet, onGuest: _onGuest)
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: users.length + 1,
                      itemBuilder: (context, index) {
                        if (index == users.length) {
                          return _AddUserCard(onTap: _openAddSheet);
                        }
                        final user = users[index];
                        return UserCard(
                          user: user,
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            final isFirst = widget.isFirstLaunch;
                            await userProvider.selectUser(user);
                            if (!context.mounted) return;
                            if (isFirst) {
                              navigator.pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            } else {
                              navigator.pop();
                            }
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _onGuest,
                child: const Text('게스트 모드로 측정'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _onGuest() async {
    final navigator = Navigator.of(context);
    final isFirst = widget.isFirstLaunch;
    await context.read<UserProvider>().selectGuest();
    if (!context.mounted) return;
    if (isFirst) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      navigator.pop();
    }
  }
}

class _AddUserCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddUserCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 36),
              SizedBox(height: 8),
              Text('새 사용자'),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onGuest;
  const _EmptyState({required this.onAdd, required this.onGuest});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('아직 등록된 사용자가 없어요.'),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.person_add_alt),
          label: const Text('첫 사용자 등록'),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onGuest, child: const Text('게스트로 바로 측정')),
      ],
    );
  }
}
