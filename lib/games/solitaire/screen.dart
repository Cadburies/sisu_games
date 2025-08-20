import 'package:flutter/material.dart';

class SolitaireScreen extends StatelessWidget {
  const SolitaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/games/solitaire/icon.jpg',
              height: 36,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.casino, size: 36),
            ),
            const SizedBox(width: 12),
            Text(
              'Solitaire',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
            'Solitaire Game',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
