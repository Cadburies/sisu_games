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
  static const Color errorBackground = Color(0xFFB71C1C);
  static const Color successBackground = Color(0xFF388E3C);

  // Accent colors
  static const Color borderAccent = Color(0xFFB71C1C);
  static const Color selectedAccent = Color(0xFFFBC02D);
  static const Color disabledAccent = Color(0xFF757575);

  // Overlay colors
  static const Color weatheredWoodOverlay = Color(0x33432416);
  static const Color selectedOverlay = Color(0x33FFD700);
  static const Color disabledOverlay = Color(0x66000000);

  // Text styles with shadows for better readability
  static TextStyle get _baseTextStyle => const TextStyle(
    fontFamily: 'RuneFont',
    color: bodyText,
    shadows: [
      Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 2),
    ],
  );

  static TextStyle get titleStyle => _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: titleText,
  );

  // Theme configuration
  static ThemeData get theme => ThemeData(
    primarySwatch: Colors.brown,
    fontFamily: 'RuneFont',
    scaffoldBackgroundColor: Colors.transparent,
    cardColor: cardBackground,

    // Text themes
    textTheme: TextTheme(
      headlineMedium: _baseTextStyle.copyWith(
        color: titleText,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: _baseTextStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: _baseTextStyle.copyWith(fontSize: 16),
      labelLarge: _baseTextStyle.copyWith(
        color: buttonText,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Button themes - using modern ButtonStyle
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: buttonText,
        backgroundColor: buttonBackground,
        disabledForegroundColor: buttonText.withOpacity(0.5),
        disabledBackgroundColor: buttonBackground.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: _baseTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: accentYellow, width: 2),
        ),
      ).copyWith(overlayColor: const MaterialStatePropertyAll(selectedOverlay)),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBackground,
      labelStyle: _baseTextStyle.copyWith(color: accentYellow),
      hintStyle: _baseTextStyle.copyWith(color: bodyText.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentYellow, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentYellow, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentYellow, width: 3),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: dialogBackground),
  );
}
