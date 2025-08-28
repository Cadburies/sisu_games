import 'dart:math';

import '../../../common/logic_helpers.dart';
import '../helpers.dart';
import '../models/poker_hand_rank.dart';
import 'ai_decision.dart';

class CommonHandLogic {
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
  PokerHandRank? currentAiHandRank;
  int? currentAiFaceValue;

  // Determine first player based on highest hand and face value
  void determineFirstPlayer() {
    userDice = LogicHelpers.rollDice(5);
    aiDice = LogicHelpers.rollDice(5);
    currentUserHandRank = evaluateHand(userDice);
    currentUserFaceValue = evaluateFaceValue(userDice);
    currentAiHandRank = evaluateHand(aiDice);
    currentAiFaceValue = evaluateFaceValue(aiDice);
    userTurn =
        (currentUserHandRank!.index < currentAiHandRank!.index) ||
        (currentUserHandRank == currentAiHandRank &&
            currentUserFaceValue! >= currentAiFaceValue!);
  }

  bool determineStarter(List<int> playerDice, List<int> aiDice) {
    final (playerRank, playerFace) = LiarsDiceHelpers.calculateHandRankAndFace(
      playerDice,
    );
    final (aiRank, aiFace) = LiarsDiceHelpers.calculateHandRankAndFace(aiDice);
    return LiarsDiceHelpers.isHigher(playerRank, playerFace, aiRank, aiFace);
  }

  // Add bid validation
  bool isValidBid(
    PokerHandRank newRank,
    int newFace,
    PokerHandRank? currentRank,
    int? currentFace,
  ) {
    if (currentRank == null || currentFace == null) return true;
    return LiarsDiceHelpers.isHigher(
      newRank,
      newFace,
      currentRank,
      currentFace,
    );
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
    return PokerHandRank.highCard;
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
        userDice[i] = LogicHelpers.rollDice(1)[0];
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
    if (declaredHandRank == null || declaredFaceValue == null) {
      return false;
    }
    PokerHandRank actualRank;
    int? actualFace;
    if (userTurn) {
      // User challenging AI
      actualRank = currentAiHandRank!;
      actualFace = currentAiFaceValue;
    } else {
      // AI challenging user
      actualRank = currentUserHandRank!;
      actualFace = currentUserFaceValue;
    }
    bool challengeSuccess =
        (declaredHandRank!.index < actualRank.index) ||
        (declaredHandRank == actualRank && declaredFaceValue! > actualFace!);
    if (challengeSuccess) {
      // Challenger was right, challenged loses a counter
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
    currentAiHandRank = null;
    currentAiFaceValue = null;
    bidHistory.clear();
    determineFirstPlayer();
  }

  // Add these methods inside the CommonHandLogic class
  bool shouldAiChallenge() {
    if (declaredHandRank == null || declaredFaceValue == null) return false;

    // Challenge if declared hand is much better than AI's actual hand
    if (declaredHandRank!.index + 2 < currentAiHandRank!.index) {
      return true;
    }

    // Challenge if same rank but declared face value is suspiciously high
    if (declaredHandRank == currentAiHandRank &&
        declaredFaceValue! > currentAiFaceValue! + 2) {
      return true;
    }

    // Random challenge with low probability
    return Random().nextDouble() < 0.1; // 10% chance to challenge anyway
  }

  PokerHandRank calculateHigherRank() {
    if (declaredHandRank == null) {
      return currentAiHandRank ?? PokerHandRank.highCard;
    }

    // Try to declare one rank higher than current declaration
    final nextRankIndex = (declaredHandRank!.index - 1).clamp(
      0,
      PokerHandRank.values.length - 1,
    );
    return PokerHandRank.values[nextRankIndex];
  }

  int calculateHigherFace() {
    if (declaredFaceValue == null) {
      return currentAiFaceValue ?? 1;
    }

    // If same rank, increase face value
    if (declaredHandRank == calculateHigherRank()) {
      return (declaredFaceValue! + 1).clamp(1, 6);
    }

    // For different rank, use AI's actual highest face value
    return currentAiFaceValue ?? 1;
  }

  AiDecision getAiDecision() {
    // AI decides whether to challenge or declare higher
    if (shouldAiChallenge()) {
      return AiDecision(
        isChallenge: true,
        message: 'AI challenges your declaration!',
      );
    }

    // AI declares higher hand
    final aiRank = calculateHigherRank();
    final aiFace = calculateHigherFace();

    return AiDecision(
      isChallenge: false,
      rank: aiRank,
      faceValue: aiFace,
      message:
          'AI declares ${aiRank.name} of ${LiarsDiceHelpers.faceToString(aiFace)}',
    );
  }
}
