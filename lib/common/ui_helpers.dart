import 'package:flutter/material.dart';

/// Common reusable UI widgets across games with Viking theme.
class UIHelpers {
  /// Themed dropdown menu with Viking styling
  static Widget themedDropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String hint,
    required BuildContext context,
    Color backgroundColor = const Color(0xFF4A2C2A), // Weathered wood brown
    Color textColor = Colors.amberAccent,
  }) {
    return DropdownButton<T>(
      value: value,
      hint: Text(
        hint,
        style: TextStyle(color: textColor, fontFamily: 'RuneFont'),
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor: backgroundColor,
      style: TextStyle(color: textColor, fontFamily: 'RuneFont'),
      iconEnabledColor: textColor,
      underline: Container(height: 2, color: textColor),
    );
  }

  /// Standard player score/turn display with Viking theme
  static Widget playerStatus(String name, int score, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.blueGrey[700]?.withValues(alpha: 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[100]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.shield, color: isActive ? Colors.blue : Colors.grey),
          const SizedBox(width: 6),
          Text(
            "$name: $score",
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'RuneFont',
              color: Colors.amber[100],
            ),
          ),
        ],
      ),
    );
  }

  /// Viking-themed dice rendering for Liar’s Dice, Yatzy
  static Widget vikingDiceFace(int value, {double size = 55}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber[100]!, width: 2),
        borderRadius: BorderRadius.circular(6),
        color: Colors.brown[900],
      ),
      alignment: Alignment.center,
      child: Text(
        value.toString(),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.amber[100],
          fontFamily: 'RuneFont',
        ),
      ),
    );
  }

  /// Card rendering for Poker/Solitaire/Uno/Cribbage with Viking theme
  static Widget cardFace(
    String label, {
    double width = 60,
    double height = 90,
    Color color = const Color(0xFF3C2F2F), // Deep weathered wood
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.amber[100]!, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Colors.amber[100],
          fontFamily: 'RuneFont',
        ),
      ),
    );
  }

  /// Action button with Viking theme
  static Widget actionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.amberAccent,
        shape: const StadiumBorder(), // Axe-like shape
      ),
      child: Text(
        label,
        style: TextStyle(fontFamily: 'RuneFont', fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Generic status banner with Viking theme
  static Widget statusBanner(String message) {
    return Container(
      width: double.infinity,
      color: Colors.grey[900], // Stormy night sky
      padding: const EdgeInsets.all(8),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.amber[100],
          fontFamily: 'RuneFont',
        ),
      ),
    );
  }
}
