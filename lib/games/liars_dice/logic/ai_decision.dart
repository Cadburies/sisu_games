import '../models/poker_hand_rank.dart';

class AiDecision {
  final bool isChallenge;
  final PokerHandRank? rank;
  final int? faceValue;
  final String message;

  AiDecision({
    required this.isChallenge,
    this.rank,
    this.faceValue,
    required this.message,
  });
}

