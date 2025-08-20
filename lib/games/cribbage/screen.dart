import 'package:flutter/material.dart';

class CribbageScreen extends StatelessWidget {
  const CribbageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/games/cribbage/icon.jpg',
              height: 36,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.casino, size: 36),
            ),
            const SizedBox(width: 12),
            Text('Cribbage', style: Theme.of(context).textTheme.headlineMedium),
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
            'Cribbage (Adapted with Pegs) Game',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
