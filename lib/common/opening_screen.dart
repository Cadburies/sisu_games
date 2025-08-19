import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for single/multiplayer toggle state
final isMultiplayerProvider = StateProvider<bool>((ref) => false);

class OpeningScreen extends ConsumerWidget {
  const OpeningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMultiplayer = ref.watch(isMultiplayerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/common/longship_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Image.asset(
                'assets/icon/icon.jpg',
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  size: 100,
                  color: Colors.amberAccent,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildGameIcon(
                      context,
                      'Backgammon',
                      'assets/games/backgammon/icon.jpg',
                      '/backgammon',
                    ),
                    _buildGameIcon(
                      context,
                      'Checkers',
                      'assets/games/checkers/icon.jpg',
                      '/checkers',
                    ),
                    _buildGameIcon(
                      context,
                      'Cribbage',
                      'assets/games/cribbage/icon.jpg',
                      '/cribbage',
                    ),
                    _buildGameIcon(
                      context,
                      'Liar\'s Dice',
                      'assets/games/liars_dice/icon.jpg',
                      '/liars_dice',
                    ),
                    _buildGameIcon(
                      context,
                      'Poker',
                      'assets/games/poker/icon.jpg',
                      '/poker',
                    ),
                    _buildGameIcon(
                      context,
                      'Solitaire',
                      'assets/games/solitaire/icon.jpg',
                      '/solitaire',
                    ),
                    _buildGameIcon(
                      context,
                      'Uno',
                      'assets/games/uno/icon.jpg',
                      '/uno',
                    ),
                    _buildGameIcon(
                      context,
                      'Yatzy',
                      'assets/games/yatzy/icon.jpg',
                      '/yatzy',
                    ),
                  ],
                ),
              ),
            ),
            _buildToggle(context, ref, isMultiplayer),
          ],
        ),
      ),
    );
  }

  Widget _buildGameIcon(
    BuildContext context,
    String title,
    String imagePath,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          route,
        ); // Navigate to the respective game screen
      },
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 80,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image,
                size: 80,
                color: Colors.amberAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(BuildContext context, WidgetRef ref, bool isMultiplayer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SwitchListTile(
        title: const Text(
          'Multiplayer Mode',
          style: TextStyle(fontFamily: 'RuneFont', color: Colors.amberAccent),
        ),
        value: isMultiplayer,
        onChanged: (value) {
          ref.read(isMultiplayerProvider.notifier).state = value;
        },
        activeColor: Colors.brown[700],
        thumbIcon: WidgetStateProperty.all(Icon(Icons.sports_esports)),
      ),
    );
  }
}
