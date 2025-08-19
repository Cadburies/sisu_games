import 'package:flutter/material.dart';

class UnoScreen extends StatelessWidget {
  const UnoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/common/longship_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'Uno Game',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
