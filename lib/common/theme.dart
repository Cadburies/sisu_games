import 'package:flutter/material.dart';

class VikingTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Colors.blueGrey[800], // Deep fjord blue
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.brown[700], // Weathered wood brown
        primary: Colors.blueGrey[800],
        surface: Colors.grey[900],
      ),
      scaffoldBackgroundColor: Colors.grey[900], // Stormy night sky
      cardColor: Colors.brown[900], // Plank wood for cards/boards
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            fontFamily: 'RuneFont',
            color: Colors.amber[100],
            fontSize: 16), // Rune-etched text
        headlineMedium: TextStyle(
            fontFamily: 'RuneFont',
            color: Colors.grey[300],
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)), // Shield-like edges
        buttonColor: Colors.brown[800], // Horn button style
      ),
      // Add more as needed, e.g., iconTheme for axe-shaped icons
    );
  }
}
