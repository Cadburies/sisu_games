// lib/common/theme.dart
import 'package:flutter/material.dart';

class VikingTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Colors.blueGrey[800], // Deep fjord blue
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.brown[700], // Weathered wood brown
        primary: Colors.blueGrey[800],
        surface: Colors.grey[900], // Stormy night sky
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.brown[900], // Plank wood for cards/boards
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'RuneFont',
          color: Colors.amber[100],
          fontSize: 16,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'RuneFont',
          color: Colors.grey[300],
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'RuneFont',
          color: Colors.amberAccent,
          fontSize: 14,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Shield-like edges
        ),
        buttonColor: Colors.brown[800], // Horn button style
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown[700],
          foregroundColor: Colors.amberAccent,
          shape: const StadiumBorder(), // Axe-like button shape
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          textStyle: TextStyle(
            fontFamily: 'RuneFont',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.brown[900],
        labelStyle: TextStyle(
          color: Colors.amberAccent,
          fontWeight: FontWeight.bold,
          fontFamily: 'RuneFont',
        ),
        hintStyle: TextStyle(
          color: Colors.amber[200],
          fontWeight: FontWeight.bold,
          fontFamily: 'RuneFont',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.amberAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.amberAccent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.yellow, width: 2),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.amber[200], // Rune-etched icons
        size: 24,
      ),
    );
  }
}
