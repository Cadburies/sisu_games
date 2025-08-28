import '../models/poker_hand_rank.dart';

class GameState {
  final String phase;
  final List<int> playerDice;
  final List<int> aiDice;
  final List<bool> holds;
  final String statusMessage;
  final bool rollButtonEnabled;
  final String? currentTurn;
  final Map<String, dynamic>? currentBid;
  final bool showAiDice;
  final PokerHandRank? declaredRank;
  final int? declaredFace;

  GameState({
    required this.phase,
    required this.playerDice,
    required this.aiDice,
    required this.holds,
    required this.statusMessage,
    required this.rollButtonEnabled,
    this.currentTurn,
    this.currentBid,
    this.showAiDice = false,
    this.declaredRank,
    this.declaredFace,
  });

  GameState copyWith({
    String? phase,
    List<int>? playerDice,
    List<int>? aiDice,
    List<bool>? holds,
    String? statusMessage,
    bool? rollButtonEnabled,
    String? currentTurn,
    Map<String, dynamic>? currentBid,
    bool? showAiDice,
    PokerHandRank? declaredRank,
    int? declaredFace,
  }) {
    return GameState(
      phase: phase ?? this.phase,
      playerDice: playerDice ?? this.playerDice,
      aiDice: aiDice ?? this.aiDice,
      holds: holds ?? this.holds,
      statusMessage: statusMessage ?? this.statusMessage,
      rollButtonEnabled: rollButtonEnabled ?? this.rollButtonEnabled,
      currentTurn: currentTurn ?? this.currentTurn,
      currentBid: currentBid ?? this.currentBid,
      showAiDice: showAiDice ?? this.showAiDice,
      declaredRank: declaredRank ?? this.declaredRank,
      declaredFace: declaredFace ?? this.declaredFace,
    );
  }
}
