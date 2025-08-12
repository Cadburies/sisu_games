import 'package:flutter/material.dart';
import 'common/theme.dart'; // Adjust path as needed

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sisu Games',
      theme: VikingTheme.theme,
      home: Scaffold(
        // Temporary home; we'll replace with OpeningScreen later
        body: Center(child: Text('Welcome to Sisu Games!')),
      ),
    );
  }
}

