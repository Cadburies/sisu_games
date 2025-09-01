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
  final int playerCounters;
  final int aiCounters;
  final List<Map<String, dynamic>> bidHistory;
  final String? winner;
  final bool showNewRoundButton;

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
    this.playerCounters = 10,
    this.aiCounters = 10,
    this.bidHistory = const [],
    this.winner,
    this.showNewRoundButton = false,
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
    int? playerCounters,
    int? aiCounters,
    List<Map<String, dynamic>>? bidHistory,
    String? winner,
    bool? showNewRoundButton,
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
      playerCounters: playerCounters ?? this.playerCounters,
      aiCounters: aiCounters ?? this.aiCounters,
      bidHistory: bidHistory ?? this.bidHistory,
      winner: winner ?? this.winner,
      showNewRoundButton: showNewRoundButton ?? this.showNewRoundButton,
    );
  }
}
