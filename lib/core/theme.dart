import 'package:flutter/material.dart';

class AppColors {
  // Colori di base del tema scuro
  static const Color background = Color(0xFF121214);
  static const Color surface = Color(0xFF1E1E24);
  static const Color primary = Color(0xFFFFD700); // Oro
  static const Color secondary = Color(0xFFE0E0E0); // Argento
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}