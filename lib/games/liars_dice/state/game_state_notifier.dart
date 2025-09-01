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
          statusMessage: 'Roll dice to determine first player!',
          rollButtonEnabled: true,
          playerCounters: 10,
          aiCounters: 10,
          bidHistory: [],
        ),
      ) {
    // Initialize the game by determining first player
    _initializeGame();
  }

  void _initializeGame() {
    logic.determineFirstPlayer();
    final userTurn = logic.userTurn;

    // Update state with initial dice rolls for first player determination
    state = state.copyWith(
      playerDice: logic.userDice,
      aiDice: logic.aiDice,
      currentTurn: userTurn ? 'player' : 'ai',
      statusMessage: userTurn
          ? 'You go first! Roll your dice for your turn.'
          : 'AI goes first. AI is rolling...',
      rollButtonEnabled: userTurn, // Only enable roll if it's player's turn
      phase: 'gameplay',
    );

    if (!userTurn) {
      // AI's turn - simulate AI rolling
      Timer(const Duration(seconds: 2), () {
        _aiRollDice();
      });
    }
  }

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

    // Validate that the declaration is higher than previous
    if (!logic.canDeclare(rankEnum, face)) {
      // Show error message and don't proceed
      state = state.copyWith(
        statusMessage: 'Declaration must be higher than previous bid!',
      );
      return;
    }

    // Update the declared values in logic
    logic.declareHand(rankEnum, face);

    // Add to bid history
    final newBidHistory = List<Map<String, dynamic>>.from(state.bidHistory);
    newBidHistory.add({
      'player': 'You',
      'rank': rankEnum.name,
      'face': face,
    });

    state = state.copyWith(
      declaredRank: rankEnum,
      declaredFace: face,
      currentBid: {'rank': rankEnum, 'face': face},
      statusMessage: 'AI is thinking...',
      currentTurn: 'ai',
      showAiDice: false,
      bidHistory: newBidHistory,
    );

    // Simulate AI thinking
    Timer(const Duration(seconds: 2), () {
      _aiTurn();
    });
  }

  void acceptDeclaration() {
    // Accept means continue to next turn without challenging
    // Transfer dice state to accepting player and continue gameplay
    if (state.currentTurn == 'player') {
      // Player accepted AI's declaration, now it's player's turn to roll
      state = state.copyWith(
        declaredRank: null,
        declaredFace: null,
        statusMessage: 'Declaration accepted. Your turn to roll!',
        currentTurn: 'player',
        rollButtonEnabled: true,
        showAiDice: false,
      );
    } else {
      // AI accepted player's declaration, now it's AI's turn
      state = state.copyWith(
        declaredRank: null,
        declaredFace: null,
        statusMessage: 'AI accepted. AI\'s turn.',
        currentTurn: 'ai',
        showAiDice: false,
      );

      // AI's turn - simulate AI rolling and declaring
      Timer(const Duration(seconds: 2), () {
        _aiRollDice();
      });
    }
  }

  void challenge() {
    state = state.copyWith(showAiDice: true, phase: 'challenge');

    final success = logic.challenge();
    
    // Update counters from logic
    state = state.copyWith(
      playerCounters: logic.userCounters,
      aiCounters: logic.aiCounters,
    );

    if (logic.winner != null) {
      state = state.copyWith(
        statusMessage: logic.winner == 'User' ? 'Victory! 🏆' : 'Defeat! 💀',
        phase: 'game_over',
        winner: logic.winner,
      );
    } else {
      // Determine who wins the challenge and gets to start next round
      final challengeWinner = success ? 'player' : 'ai';
      state = state.copyWith(
        statusMessage: success
            ? 'Challenge successful! AI loses a counter.'
            : 'Challenge failed! You lose a counter.',
        currentTurn: challengeWinner, // Winner of challenge starts next round
        showNewRoundButton: true,
        phase: 'gameplay',
        // Hide accept/challenge buttons after challenge
        declaredRank: null,
        declaredFace: null,
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

  void _aiRollDice() {
    // AI rolls its dice
    logic.rollDice();

    state = state.copyWith(
      aiDice: logic.aiDice,
      statusMessage: 'AI rolled. AI is declaring...',
    );

    // AI makes its declaration
    Timer(const Duration(seconds: 1), () {
      _aiTurn();
    });
  }

  void startNewRound() {
    // Determine who should start the new round (winner of the challenge)
    final currentTurnPlayer = state.currentTurn;
    final isPlayerTurn = currentTurnPlayer == 'player';
    
    // Reset round-specific state
    state = state.copyWith(
      declaredRank: null,
      declaredFace: null,
      showAiDice: false,
      rollButtonEnabled: isPlayerTurn, // Only enable if it's player's turn
      statusMessage: isPlayerTurn 
          ? 'Roll dice for your turn!'
          : 'AI is rolling...',
      phase: 'gameplay',
      showNewRoundButton: false,
      bidHistory: [], // Clear bid history for new round
      holds: List.filled(5, false), // Reset holds
      currentTurn: currentTurnPlayer, // Maintain the current turn
    );

    // Reset logic state for new round
    logic.previousDeclaredHandRank = null;
    logic.previousDeclaredFaceValue = null;
    logic.declaredHandRank = null;
    logic.declaredFaceValue = null;
    logic.roundActive = true;
    logic.bidHistory.clear();
    logic.userTurn = isPlayerTurn; // Update logic turn state

    // If it's AI's turn, start AI rolling after a delay
    if (!isPlayerTurn) {
      Timer(const Duration(seconds: 2), () {
        _aiRollDice();
      });
    }
  }

  void restartGame() {
    // Reset everything to initial state
    logic.reset();
    
    state = GameState(
      phase: 'determine_starter',
      playerDice: List.filled(5, 1),
      aiDice: List.filled(5, 1),
      holds: List.filled(5, false),
      statusMessage: 'Roll dice to determine first player!',
      rollButtonEnabled: true,
      playerCounters: 10,
      aiCounters: 10,
      bidHistory: [],
    );

    // Re-initialize the game
    _initializeGame();
  }

  void _aiTurn() {
    final aiDecision = logic.getAiDecision();

    if (aiDecision.isChallenge) {
      // AI is challenging the player's declaration
      state = state.copyWith(
        showAiDice: true,
        statusMessage: 'AI challenges your declaration!',
        phase: 'challenge',
      );

      // Process the challenge
      Timer(const Duration(seconds: 1), () {
        final success = logic.challenge();
        
        // Update counters from logic
        state = state.copyWith(
          playerCounters: logic.userCounters,
          aiCounters: logic.aiCounters,
        );

        if (logic.winner != null) {
          state = state.copyWith(
            statusMessage: logic.winner == 'User'
                ? 'Victory! 🏆'
                : 'Defeat! 💀',
            phase: 'game_over',
            winner: logic.winner,
          );
        } else {
          state = state.copyWith(
            statusMessage: success
                ? 'AI challenge successful! You lose a counter.'
                : 'AI challenge failed! AI loses a counter.',
            currentTurn: success ? 'ai' : 'player',
            showNewRoundButton: true,
            phase: 'gameplay',
          );
        }
      });
    } else {
      // AI is making a declaration
      // Add to bid history
      final newBidHistory = List<Map<String, dynamic>>.from(state.bidHistory);
      newBidHistory.add({
        'player': 'AI',
        'rank': aiDecision.rank!.name,
        'face': aiDecision.faceValue!,
      });

      state = state.copyWith(
        declaredRank: aiDecision.rank,
        declaredFace: aiDecision.faceValue,
        statusMessage:
            'AI declares ${aiDecision.rank!.name} of ${aiDecision.faceValue}.\nAccept or Challenge?',
        currentTurn: 'player',
        showAiDice: false,
        bidHistory: newBidHistory,
      );
    }
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((
  ref,
) {
  return GameStateNotifier();
});
