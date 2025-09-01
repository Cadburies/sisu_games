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

  void determineFirstPlayer() {
    // Roll dice for both players
    userDice = LogicHelpers.rollDice(5);
    aiDice = LogicHelpers.rollDice(5);

    // Calculate ranks and faces using LiarsDiceHelpers
    final (playerRank, playerFace) = LiarsDiceHelpers.calculateHandRankAndFace(
      userDice,
    );
    final (aiRank, aiFace) = LiarsDiceHelpers.calculateHandRankAndFace(aiDice);

    // Update internal state
    currentUserHandRank = playerRank;
    currentUserFaceValue = playerFace;
    currentAiHandRank = aiRank;
    currentAiFaceValue = aiFace;

    // Determine who starts using isHigher
    userTurn = LiarsDiceHelpers.isHigher(
      playerRank,
      playerFace,
      aiRank,
      aiFace,
    );
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

    // Combine all dice from both players for evaluation
    List<int> allDice = [...userDice, ...aiDice];

    // Evaluate the combined hand
    PokerHandRank actualRank = evaluateHand(allDice);
    int? actualFace = evaluateFaceValue(allDice);

    // Compare declared bid to actual combined hand
    // Challenge succeeds if actual hand is WORSE than declared (declarer was lying)
    bool challengeSuccess = !LiarsDiceHelpers.isHigher(
      actualRank,
      actualFace ?? 1,
      declaredHandRank!,
      declaredFaceValue!,
    ) && !(actualRank == declaredHandRank && actualFace == declaredFaceValue);

    if (challengeSuccess) {
      // Challenge was successful - declarer was lying, so declarer loses counter
      if (!userTurn) {
        // AI is challenging user's declaration, user loses counter
        userCounters = (userCounters - 1).clamp(0, 10);
      } else {
        // User is challenging AI's declaration, AI loses counter
        aiCounters = (aiCounters - 1).clamp(0, 10);
      }
    } else {
      // Challenge failed - declarer was telling truth, challenger loses counter
      if (!userTurn) {
        // AI challenged but was wrong, AI loses counter
        aiCounters = (aiCounters - 1).clamp(0, 10);
      } else {
        // User challenged but was wrong, user loses counter
        userCounters = (userCounters - 1).clamp(0, 10);
      }
    }

    // Check for winner
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

  // AI Logic: When there is a pair, hold the pair and roll the three odd dice
  void aiRollDice() {
    // Reset AI hold state
    List<bool> aiDiceHold = List.filled(5, false);

    // Find pairs and hold them
    Map<int, List<int>> diceGroups = {};
    for (int i = 0; i < aiDice.length; i++) {
      int die = aiDice[i];
      if (!diceGroups.containsKey(die)) {
        diceGroups[die] = [];
      }
      diceGroups[die]!.add(i);
    }

    // Hold pairs (exactly 2 of a kind)
    for (var entry in diceGroups.entries) {
      if (entry.value.length == 2) {
        // Hold the pair
        aiDiceHold[entry.value[0]] = true;
        aiDiceHold[entry.value[1]] = true;
      }
    }

    // Roll non-held dice
    for (int i = 0; i < 5; i++) {
      if (!aiDiceHold[i]) {
        aiDice[i] = LogicHelpers.rollDice(1)[0];
      }
    }

    // Update AI's current hand
    currentAiHandRank = evaluateHand(aiDice);
    currentAiFaceValue = evaluateFaceValue(aiDice);
  }

  // AI decision making for challenge/accept
  bool shouldAiChallenge() {
    if (declaredHandRank == null || declaredFaceValue == null) return false;

    // Challenge if the declared hand seems too good to be true
    // (AI's actual hand is much worse than declared)
    if (declaredHandRank!.index > currentAiHandRank!.index + 1) {
      return true;
    }

    // Challenge if same rank but declared face is higher than AI's
    if (declaredHandRank == currentAiHandRank &&
        declaredFaceValue! > currentAiFaceValue!) {
      return true;
    }

    // 20% chance to challenge randomly for unpredictability
    return Random().nextDouble() < 0.2;
  }

  // Calculate what AI should declare (must be higher than previous)
  (PokerHandRank, int) calculateAiDeclaration() {
    PokerHandRank aiRank;
    int aiFace;

    if (previousDeclaredHandRank == null) {
      // First declaration - use AI's actual hand
      aiRank = currentAiHandRank ?? PokerHandRank.highCard;
      aiFace = currentAiFaceValue ?? 1;
    } else {
      // Must declare higher than previous
      if (previousDeclaredHandRank!.index > 0) {
        // Can go to next higher rank
        aiRank = PokerHandRank.values[previousDeclaredHandRank!.index - 1];
        aiFace = previousDeclaredFaceValue ?? 1;
      } else {
        // At highest rank, must increase face value
        aiRank = previousDeclaredHandRank!;
        aiFace = (previousDeclaredFaceValue ?? 1) + 1;
        if (aiFace > 6) aiFace = 6; // Cap at 6
      }
    }

    return (aiRank, aiFace);
  }

  AiDecision getAiDecision() {
    // First, AI rolls its dice according to strategy
    aiRollDice();

    // Then decide whether to challenge or declare
    if (shouldAiChallenge()) {
      return AiDecision(
        isChallenge: true,
        message: 'AI challenges your declaration!',
      );
    }

    // Calculate and make declaration
    final (aiRank, aiFace) = calculateAiDeclaration();

    return AiDecision(
      isChallenge: false,
      rank: aiRank,
      faceValue: aiFace,
      message: 'AI declares ${aiRank.name} of ${LiarsDiceHelpers.faceToString(aiFace)}',
    );
  }
}
