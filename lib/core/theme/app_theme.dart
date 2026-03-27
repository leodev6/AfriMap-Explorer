import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accent = Color(0xFFFF9800);
  static const Color accentLight = Color(0xFFFFE0B2);

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF212121);

  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);

  static const Color correct = Color(0xFF4CAF50);
  static const Color incorrect = Color(0xFFF44336);

  static const List<Color> cardColors = [
    Color(0xFFE3F2FD),
    Color(0xFFF3E5F5),
    Color(0xFFE8F5E9),
    Color(0xFFFFF3E0),
    Color(0xFFFCE4EC),
    Color(0xFFE0F7FA),
    Color(0xFFFBE9E7),
    Color(0xFFE8EAF6),
    Color(0xFFF1F8E9),
    Color(0xFFFFF8E1),
  ];

  static Color getCardColor(int index) {
    return cardColors[index % cardColors.length];
  }
}

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.onSurface,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle quizQuestion = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static const TextStyle score = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}
