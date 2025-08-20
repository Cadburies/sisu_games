import 'package:flutter/material.dart';

class CheckersScreen extends StatelessWidget {
  const CheckersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/games/checkers/icon.jpg',
              height: 36,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.casino, size: 36),
            ),
            const SizedBox(width: 12),
            Text('Checkers', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/common/longship_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'Checkers (Viking Chess) Game',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
