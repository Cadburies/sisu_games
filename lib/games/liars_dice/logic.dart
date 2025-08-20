import 'dart:math';
import 'dart:convert';

enum PokerHandRank {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  highStraight,
  lowStraight,
  threeOfAKind,
  twoPair,
  onePair,
  highDie,
}

class CommonHandLiarDiceLogic {
  final Random _random = Random();
  int userCounters = 10;
  int aiCounters = 10;
  List<int> userDice = List.filled(5, 0);
  List<int> aiDice = List.filled(5, 0);
  List<bool> userDiceHold = List.filled(5, false); // Hold/roll state
  PokerHandRank? currentUserHandRank;
  int? currentUserFaceValue; // Track the highest face value in the hand
  PokerHandRank? declaredHandRank;
  int? declaredFaceValue;
  PokerHandRank? previousDeclaredHandRank;
  int? previousDeclaredFaceValue;
  bool userTurn = true;
  String? winner;
  bool roundActive = true;
  List<Map<String, dynamic>> bidHistory = []; // Now includes face value

  // Determine first player based on highest hand and face value
  void determineFirstPlayer() {
    userDice = List.generate(5, (_) => _random.nextInt(6) + 1);
    aiDice = List.generate(5, (_) => _random.nextInt(6) + 1);
    currentUserHandRank = evaluateHand(userDice);
    currentUserFaceValue = userDice.reduce((a, b) => max(a, b));
    final aiHandRank = evaluateHand(aiDice);
    final aiFaceValue = aiDice.reduce((a, b) => max(a, b));
    userTurn =
        (currentUserHandRank!.index < aiHandRank.index) ||
        (currentUserHandRank == aiHandRank &&
            currentUserFaceValue! >= aiFaceValue);
  }

  PokerHandRank evaluateHand(List<int> dice) {
    final counts = List.filled(7, 0);
    for (var d in dice) {
      counts[d]++;
    }
    final sorted = [...dice]..sort();
    if (counts.contains(5)) return PokerHandRank.fiveOfAKind;
    if (counts.contains(4)) return PokerHandRank.fourOfAKind;
    if (counts.contains(3) && counts.contains(2)) {
      return PokerHandRank.fullHouse;
    }
    if (sorted.join() == '12345') return PokerHandRank.lowStraight;
    if (sorted.join() == '23456') return PokerHandRank.highStraight;
    if (counts.contains(3)) return PokerHandRank.threeOfAKind;
    if (counts.where((c) => c == 2).length == 2) return PokerHandRank.twoPair;
    if (counts.contains(2)) return PokerHandRank.onePair;
    return PokerHandRank.highDie;
  }

  int? evaluateFaceValue(List<int> dice) {
    // Return the highest face value among matching dice for the declared rank
    final counts = List.filled(7, 0);
    for (var d in dice) {
      counts[d]++;
    }
    if (counts.contains(4)) {
      return dice.where((d) => counts[d] == 4).reduce(max);
    }
    if (counts.contains(3)) {
      return dice.where((d) => counts[d] == 3).reduce(max);
    }
    if (counts.contains(2) && counts.where((c) => c == 2).length == 2) {
      return dice.where((d) => counts[d] == 2).reduce(max);
    }
    return dice.reduce(max); // For highDie or straights
  }

  bool canDeclare(PokerHandRank rank, int faceValue) {
    if (previousDeclaredHandRank == null && previousDeclaredFaceValue == null) {
      return true;
    }
    if (rank.index < previousDeclaredHandRank!.index) return true;
    if (rank.index == previousDeclaredHandRank!.index &&
        faceValue > previousDeclaredFaceValue!) {
      return true;
    }
    return false;
  }

  void declareHand(PokerHandRank rank, int faceValue) {
    if (!canDeclare(rank, faceValue)) {
      throw Exception('Must declare a higher hand or face value.');
    }
    declaredHandRank = rank;
    declaredFaceValue = faceValue;
    previousDeclaredHandRank = rank;
    previousDeclaredFaceValue = faceValue;
    userTurn = !userTurn;
    bidHistory.add({'rank': rank.index, 'faceValue': faceValue});
  }

  void rollDice() {
    for (int i = 0; i < 5; i++) {
      if (!userDiceHold[i]) {
        userDice[i] = _random.nextInt(6) + 1;
      }
    }
    currentUserHandRank = evaluateHand(userDice);
    currentUserFaceValue = evaluateFaceValue(userDice);
    userDiceHold.fillRange(0, 5, false); // Reset hold state after roll
  }

  void toggleDiceHold(int index) {
    if (index >= 0 && index < 5) {
      userDiceHold[index] = !userDiceHold[index];
    }
  }

  bool challenge() {
    if (declaredHandRank == null ||
        declaredFaceValue == null ||
        currentUserHandRank == null ||
        currentUserFaceValue == null) {
      return false;
    }
    bool challengeSuccess =
        (declaredHandRank!.index < currentUserHandRank!.index) ||
        (declaredHandRank == currentUserHandRank &&
            declaredFaceValue! < currentUserFaceValue!);
    if (challengeSuccess) {
      // Challenger was right, last player loses a counter
      if (userTurn) {
        aiCounters = (aiCounters - 1).clamp(0, 10);
      } else {
        userCounters = (userCounters - 1).clamp(0, 10);
      }
    } else {
      // Challenger was wrong, challenger loses a counter
      if (userTurn) {
        userCounters = (userCounters - 1).clamp(0, 10);
      } else {
        aiCounters = (aiCounters - 1).clamp(0, 10);
      }
    }
    if (userCounters == 0) winner = 'AI';
    if (aiCounters == 0) winner = 'User';
    roundActive = false;
    return challengeSuccess;
  }

  void reset() {
    userCounters = 10;
    aiCounters = 10;
    userDice = List.filled(5, 0);
    aiDice = List.filled(5, 0);
    userDiceHold = List.filled(5, false);
    currentUserHandRank = null;
    currentUserFaceValue = null;
    declaredHandRank = null;
    declaredFaceValue = null;
    previousDeclaredHandRank = null;
    previousDeclaredFaceValue = null;
    userTurn = true;
    winner = null;
    roundActive = true;
    bidHistory.clear();
    determineFirstPlayer();
  }

  MultiplayerLiarDiceState toMultiplayerState() {
    return MultiplayerLiarDiceState(
      playerDiceCount: userCounters,
      opponentDiceCount: aiCounters,
      bidHistory: bidHistory,
      playerTurn: userTurn,
      winner: winner,
    );
  }

  void fromMultiplayerState(MultiplayerLiarDiceState state) {
    userCounters = state.playerDiceCount;
    aiCounters = state.opponentDiceCount;
    bidHistory = state.bidHistory;
    userTurn = state.playerTurn;
    winner = state.winner;
  }
}

class MultiplayerLiarDiceState {
  final int playerDiceCount;
  final int opponentDiceCount;
  final List<Map<String, dynamic>> bidHistory;
  final bool playerTurn;
  final String? winner;

  MultiplayerLiarDiceState({
    required this.playerDiceCount,
    required this.opponentDiceCount,
    required this.bidHistory,
    required this.playerTurn,
    required this.winner,
  });

  Map<String, dynamic> toJson() => {
    'playerDiceCount': playerDiceCount,
    'opponentDiceCount': opponentDiceCount,
    'bidHistory': bidHistory,
    'playerTurn': playerTurn,
    'winner': winner,
  };

  static MultiplayerLiarDiceState fromJson(Map<String, dynamic> json) =>
      MultiplayerLiarDiceState(
        playerDiceCount: json['playerDiceCount'],
        opponentDiceCount: json['opponentDiceCount'],
        bidHistory: List<Map<String, dynamic>>.from(
          (json['bidHistory'] as List).map((e) => Map<String, dynamic>.from(e)),
        ),
        playerTurn: json['playerTurn'],
        winner: json['winner'],
      );
}
