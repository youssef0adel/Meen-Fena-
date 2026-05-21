import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF0A0A0A);
  static const Color secondaryDark = Color(0xFF141414);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color cardLight = Color(0xFF2A2A2A);
  static const Color bloodRed = Color(0xFF5C0A0A);
  static const Color bloodRedLight = Color(0xFF7A1515);
  static const Color accentRed = Color(0xFF8B1A1A);
  static const Color redGlow = Color(0xFF4A0000);
  static const Color goldAccent = Color(0xFFC8A84E);
  static const Color goldDark = Color(0xFF8B7340);
  static const Color goldLight = Color(0xFFD4B96A);
  static const Color textPrimary = Color(0xFFD0D0D0);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textMuted = Color(0xFF555555);
  static const Color suspicionAmber = Color(0xFF8B6914);
  static const Color innocentBlue = Color(0xFF1A3A5C);
  static const Color mafiaRed = Color(0xFF6B1010);

  static ThemeData darkNoirTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: primaryDark,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: 3),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: 2),
      bodyLarge: TextStyle(fontSize: 18, color: textPrimary, height: 1.5, letterSpacing: 1),
      bodyMedium: TextStyle(fontSize: 16, color: textSecondary, letterSpacing: 1),
      labelLarge: TextStyle(fontSize: 14, color: textMuted, letterSpacing: 2),
    ),
    colorScheme: const ColorScheme.dark(primary: bloodRed, secondary: goldAccent, surface: cardDark, error: mafiaRed),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 8,
      shadowColor: bloodRed.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: bloodRed.withOpacity(0.3), width: 0.5)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bloodRed,
        foregroundColor: goldAccent,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardDark,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: bloodRed.withOpacity(0.3))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: bloodRed.withOpacity(0.2))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: goldAccent.withOpacity(0.5))),
    ),
  );
}