import 'package:flutter/material.dart';

/// Laboard 二手桌遊舖品牌色：深色底 + 金色點綴。
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF1A1A18);
  static const Color surface = Color(0xFF242420);
  static const Color surfaceVariant = Color(0xFF2E2E28);
  static const Color gold = Color(0xFFC9A84C);
  static const Color goldMuted = Color(0xFF8A7333);
  static const Color textPrimary = Color(0xFFF2EFE6);
  static const Color textSecondary = Color(0xFFA8A499);
  static const Color divider = Color(0xFF3A3A33);

  static const Color success = Color(0xFF4CAF6D);
  static const Color warning = Color(0xFFE0A93A);
  static const Color error = Color(0xFFE0554A);

  // 組局狀態顏色
  static const Color statusRecruiting = success;
  static const Color statusFull = warning;
  static const Color statusStarted = textSecondary;

  // 商品新舊評級顏色 (S/A/B/C)
  static const Map<String, Color> conditionColors = {
    'S': Color(0xFFD9C36B),
    'A': Color(0xFF8FBF9F),
    'B': Color(0xFF7FA8C9),
    'C': Color(0xFFB08A6A),
  };
}
