import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/common_hand_logic.dart';
import '../models/poker_hand_rank.dart';
import 'game_state.dart';
import 'multiplayer_state.dart';

class GameStateNotifier extends StateNotifier<GameState> {
  Timer? _rollTimer;
  final Random _random = Random();
  final CommonHandLogic logic;

  GameStateNotifier()
    : logic = CommonHandLogic(),
      super(
        GameState(
          phase: 'determine_starter',
          playerDice: List.filled(5, 1),
          aiDice: List.filled(5, 1),
          holds: List.filled(5, false),
          statusMessage: 'Roll dice to start the game!',
          rollButtonEnabled: true,
        ),
      );

  void toggleHold(int index) {
    if (state.phase != 'gameplay' || state.currentTurn != 'player') return;

    final newHolds = List<bool>.from(state.holds);
    newHolds[index] = !newHolds[index];
    state = state.copyWith(holds: newHolds);
  }

  void rollDice() {
    if (!state.rollButtonEnabled) return;

    state = state.copyWith(rollButtonEnabled: false);
    int rolls = 0;

    _rollTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      rolls++;
      final newDice = List<int>.from(state.playerDice);

      for (int i = 0; i < newDice.length; i++) {
        if (!state.holds[i]) {
          newDice[i] = _random.nextInt(6) + 1;
        }
      }

      state = state.copyWith(playerDice: newDice, statusMessage: 'Rolling...');

      if (rolls >= 5) {
        timer.cancel();
        _rollTimer = null;
        state = state.copyWith(
          statusMessage: 'Select rank and face to declare',
          rollButtonEnabled: false,
          currentTurn: 'player',
        );
      }
    });
  }

  void declare(String rank, int face) {
    final rankEnum = PokerHandRank.values.firstWhere(
      (r) => r.name == rank,
      orElse: () => PokerHandRank.highCard,
    );

    state = state.copyWith(
      currentBid: {'rank': rankEnum, 'face': face},
      statusMessage: 'AI is thinking...',
      currentTurn: 'ai',
      showAiDice: false,
    );

    // Simulate AI thinking
    Timer(const Duration(seconds: 2), () {
      _aiTurn();
    });
  }

  void challenge() {
    state = state.copyWith(showAiDice: true, phase: 'challenge');

    final success = logic.challenge();
    if (logic.winner != null) {
      state = state.copyWith(
        statusMessage: logic.winner == 'User' ? 'Victory! 🏆' : 'Defeat! 💀',
        phase: 'game_over',
      );
    } else {
      state = state.copyWith(
        statusMessage: success
            ? 'Challenge successful! AI loses a counter.'
            : 'Challenge failed! You lose a counter.',
        currentTurn: success ? 'player' : 'ai',
      );
    }
  }

  void updateFromMultiplayer(MultiplayerLiarDiceState mpState) {
    state = state.copyWith(
      playerDice: List.filled(mpState.playerDiceCount, 1),
      aiDice: List.filled(mpState.opponentDiceCount, 1),
      currentTurn: mpState.playerTurn ? 'player' : 'ai',
      phase: mpState.winner != null ? 'game_over' : state.phase,
      statusMessage: mpState.winner != null
          ? '${mpState.winner} wins!'
          : '${mpState.playerTurn ? 'Your' : 'AI\'s'} turn',
      rollButtonEnabled: mpState.playerTurn && state.phase != 'game_over',
      showAiDice: mpState.winner != null,
    );
  }

  void _aiTurn() {
    final aiDecision = logic.getAiDecision();

    if (aiDecision.isChallenge) {
      state = state.copyWith(
        showAiDice: true,
        statusMessage: 'AI challenges!',
        phase: 'challenge',
      );

      final success = logic.challenge();
      if (logic.winner != null) {
        state = state.copyWith(
          statusMessage: logic.winner == 'User' ? 'Victory! 🏆' : 'Defeat! 💀',
          phase: 'game_over',
        );
      }
    } else {
      state = state.copyWith(
        declaredRank: aiDecision.rank,
        declaredFace: aiDecision.faceValue,
        statusMessage:
            'AI declares ${aiDecision.rank!.name} of ${aiDecision.faceValue}.\nAccept or Challenge?',
        currentTurn: 'player',
        showAiDice: false,
      );
    }
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((
  ref,
) {
  return GameStateNotifier();
});
