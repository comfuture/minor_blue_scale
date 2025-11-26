import 'package:flutter/material.dart';

class DesignTokens {
  static const double radius = 18;
  static const double smallRadius = 12;
  static const double cardPadding = 16;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);

  static List<BoxShadow> softShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.06),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];
}
