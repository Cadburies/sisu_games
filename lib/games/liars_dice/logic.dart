import 'dart:math';

class LiarDiceLogic {
  final Random _random = Random();
  int userDiceCount = 5;
  int aiDiceCount = 5;
  List<int> userDice = [];
  List<int> aiDice = [];
  List<Map<String, int>> bidHistory = [];
  bool userTurn = true;
  String? winner;

  void rollDice() {
    userDice = List.generate(userDiceCount, (_) => _random.nextInt(6) + 1);
    aiDice = List.generate(aiDiceCount, (_) => _random.nextInt(6) + 1);
  }

  bool canBid(int quantity, int face) {
    if (bidHistory.isEmpty) return true;
    final lastBid = bidHistory.last;
    if (quantity > lastBid['quantity']!) return true;
    if (quantity == lastBid['quantity']! && face > lastBid['face']!)
      return true;
    return false;
  }

  void bid(int quantity, int face) {
    bidHistory.add({'quantity': quantity, 'face': face});
    userTurn = !userTurn;
  }

  Map<String, int> aiBid() {
    // Simple AI: bid +1 quantity or +1 face, based on probability
    int lastQuantity = 1;
    int lastFace = 1;
    if (bidHistory.isNotEmpty) {
      lastQuantity = bidHistory.last['quantity']!;
      lastFace = bidHistory.last['face']!;
    }
    // AI logic: try to increase quantity, else face
    int aiQuantity = lastQuantity;
    int aiFace = lastFace;
    if (lastFace < 6) {
      aiFace++;
    } else {
      aiQuantity++;
      aiFace = 1;
    }
    bidHistory.add({'quantity': aiQuantity, 'face': aiFace});
    userTurn = !userTurn;
    return {'quantity': aiQuantity, 'face': aiFace};
  }

  bool challenge() {
    if (bidHistory.isEmpty) return false;
    final lastBid = bidHistory.last;
    int total =
        userDice.where((d) => d == lastBid['face']).length +
        aiDice.where((d) => d == lastBid['face']).length;
    bool success = total >= lastBid['quantity']!;
    if (success) {
      // Challenger loses a die
      if (userTurn) {
        userDiceCount = max(0, userDiceCount - 1);
      } else {
        aiDiceCount = max(0, aiDiceCount - 1);
      }
    } else {
      // Bidder loses a die
      if (userTurn) {
        aiDiceCount = max(0, aiDiceCount - 1);
      } else {
        userDiceCount = max(0, userDiceCount - 1);
      }
    }
    if (userDiceCount == 0) winner = 'AI';
    if (aiDiceCount == 0) winner = 'User';
    return success;
  }

  void reset() {
    userDiceCount = 5;
    aiDiceCount = 5;
    userDice = [];
    aiDice = [];
    bidHistory = [];
    userTurn = true;
    winner = null;
  }
}
