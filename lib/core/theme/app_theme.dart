import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF0D0D0D);
  static const Color secondaryDark = Color(0xFF1A1A1A);
  static const Color cardDark = Color(0xFF252525);
  static const Color accentRed = Color(0xFFD32F2F);
  static const Color bloodRed = Color(0xFF8B0000);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color textPrimary = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color suspicionAmber = Color(0xFFFF8F00);
  static const Color innocentBlue = Color(0xFF1565C0);
  static const Color mafiaRed = Color(0xFFC62828);

  static ThemeData darkNoirTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: accentRed,
      secondary: goldAccent,
      surface: cardDark,
      error: mafiaRed,
    ),
    // ✅ استخدم CardThemeData بدل CardTheme
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 8,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: accentRed, width: 0.5),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: 2),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimary, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    ),
  );
}