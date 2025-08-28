// lib/common/card_logic_helpers.dart
import 'dart:math';

/// Common helper functions for card logic.
class CardLogicHelpers {
  static final Random _rng = Random();

  static const List<String> rankNames = [
    'Five of a Kind',
    'Four of a Kind',
    'Full House',
    'High Straight',
    'Low Straight',
    'Three of a Kind',
    'Two Pair',
    'One Pair',
    'High Die',
  ];

  static const List<String> faceNames = [
    'Ace',
    'King',
    'Queen',
    'Jack',
    'Ten',
    'Nine',
  ];

  static const List<int> faceDiceValues = [6, 5, 4, 3, 2, 1];

  /// Standard deck generator (52 cards)
  static List<String> generateStandardDeck() {
    const suits = ['♠', '♥', '♦', '♣'];
    const ranks = [
      'A',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'J',
      'Q',
      'K',
    ];
    return [
      for (var suit in suits)
        for (var rank in ranks) '$rank$suit',
    ];
  }

  /// Uno deck generator (simplified)
  static List<String> generateUnoDeck() {
    const colors = ['Red', 'Blue', 'Green', 'Yellow'];
    const ranks = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'Skip',
      'Reverse',
      '+2',
    ];
    List<String> deck = [];
    for (var color in colors) {
      for (var rank in ranks) {
        deck.add('$rank-$color');
        if (rank != '0') deck.add('$rank-$color'); // two copies except 0
      }
    }
    deck.addAll(['Wild', 'Wild Draw Four']);
    return deck;
  }

  /// Shuffle helper
  static List<T> shuffle<T>(List<T> items) {
    items.shuffle(_rng);
    return items;
  }
}
