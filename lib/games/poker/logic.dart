enum VikingSuit { axes, shields, ravens, ships }

enum Rank {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace,
}

class Card {
  final VikingSuit suit;
  final Rank rank;
  Card(this.suit, this.rank);
}

class PokerLogic {
  List<Card> deck = [];
  PokerLogic() {
    for (var suit in VikingSuit.values) {
      for (var rank in Rank.values) {
        deck.add(Card(suit, rank));
      }
    }
    deck.shuffle();
  }
  // TODO: Implement hand evaluation (e.g., flush, straight)
}
