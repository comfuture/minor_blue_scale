import 'dart:math';

String generateId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final random = Random().nextInt(99999);
  return '${now}_$random';
}
