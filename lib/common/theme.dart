// lib/common/theme.dart
import 'package:flutter/material.dart';

class VikingTheme {
  // Base colors
  static const Color accentYellow = Color(0xFFFFD700);
  static const Color bodyText = Color(0xFFFFF8E1);
  static const Color buttonText = Color(0xFFFFF8E1);
  static const Color titleText = Color(0xFFFFD700);

  // Background colors
  static const Color cardBackground = Color(0xFF3E2723);
  static const Color buttonBackground = Color(0xFF795548);
  static const Color dialogBackground = Color(0xFF2D1B12);
  static const Color diceBackground = Color(0xFF5D4037);
  static const Color inputBackground = Color(0xFF4E342E);

  // Accent colors
  static const Color borderAccent = Color(0xFFB71C1C);
  static const Color selectedAccent = Color(0xFFFBC02D);

  // Theme configuration
  static ThemeData get theme => ThemeData(
    primarySwatch: Colors.brown,
    fontFamily: 'RuneFont',
    scaffoldBackgroundColor: Colors.transparent,
    cardColor: cardBackground,
    dialogBackgroundColor: dialogBackground,

    // Text themes
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: titleText,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'RuneFont',
      ),
      titleLarge: TextStyle(
        color: bodyText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: bodyText,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: bodyText, fontSize: 16),
      labelLarge: TextStyle(
        color: buttonText,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonBackground,
        foregroundColor: buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'RuneFont',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      fillColor: inputBackground,
      filled: true,
      labelStyle: const TextStyle(color: accentYellow),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentYellow, width: 2),
      ),
    ),
  );
}
