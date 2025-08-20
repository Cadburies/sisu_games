import 'dart:math';

/// Common game logic helpers
class LogicHelpers {
  static final Random _rng = Random();

  /// Turn management
  static int nextTurn(int currentIndex, int totalPlayers) {
    return (currentIndex + 1) % totalPlayers;
  }

  /// Dice rolling
  static List<int> rollDice(int count, {int sides = 6}) {
    return List.generate(count, (_) => _rng.nextInt(sides) + 1);
  }

  /// Basic scoring helper (Yatzy, Liar’s Dice use)
  static Map<int, int> countDice(List<int> dice) {
    Map<int, int> counts = {};
    for (var d in dice) {
      counts[d] = (counts[d] ?? 0) + 1;
    }
    return counts;
  }
}
