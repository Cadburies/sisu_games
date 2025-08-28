import 'game_state.dart';

class MultiplayerLiarDiceState {
  final int playerDiceCount;
  final int opponentDiceCount;
  final List<Map<String, int>> bidHistory;
  final bool playerTurn;
  final String? winner;

  MultiplayerLiarDiceState({
    required this.playerDiceCount,
    required this.opponentDiceCount,
    required this.bidHistory,
    required this.playerTurn,
    this.winner,
  });

  factory MultiplayerLiarDiceState.fromJson(Map<String, dynamic> json) {
    return MultiplayerLiarDiceState(
      playerDiceCount: json['playerDiceCount'],
      opponentDiceCount: json['opponentDiceCount'],
      bidHistory: List<Map<String, int>>.from(json['bidHistory']),
      playerTurn: json['playerTurn'],
      winner: json['winner'],
    );
  }

  factory MultiplayerLiarDiceState.fromGameState(GameState state) {
    return MultiplayerLiarDiceState(
      playerDiceCount: state.playerDice.length,
      opponentDiceCount: state.aiDice.length,
      bidHistory: [], // Add bid history tracking if needed
      playerTurn: state.currentTurn == 'player',
      winner: null, // Add winner logic if needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerDiceCount': playerDiceCount,
      'opponentDiceCount': opponentDiceCount,
      'bidHistory': bidHistory,
      'playerTurn': playerTurn,
      'winner': winner,
    };
  }
}
