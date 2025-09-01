// lib/games/liars_dice/screen.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../common/dice_widget.dart';
import '../../common/networking.dart';
import '../../common/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'helpers.dart';
import 'models/poker_hand_rank.dart';
import 'state/game_state.dart';
import 'state/game_state_notifier.dart';
import 'state/multiplayer_state.dart';

// Provider for single/multiplayer toggle state
final isMultiplayerProvider = StateProvider<bool>((ref) => false);

class LiarsDiceScreen extends ConsumerStatefulWidget {
  const LiarsDiceScreen({super.key});

  @override
  ConsumerState<LiarsDiceScreen> createState() => _LiarsDiceScreenState();
}

class _LiarsDiceScreenState extends ConsumerState<LiarsDiceScreen> {
  bool multiplayerDialogShown = false;
  bool isConnecting = false;
  String? connectionStatus;
  WebSocketChannel? channel;
  bool isHost = false;
  String? selectedRank;
  String? selectedFaceValue;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeShowMultiplayerDialog(),
    );
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _listenToChannel() {
    if (channel == null) return;
    channel!.stream.listen((data) {
      final gameState = ref.read(gameStateProvider.notifier);
      final state = MultiplayerLiarDiceState.fromJson(jsonDecode(data));
      gameState.updateFromMultiplayer(state);
    });
  }

  void _maybeShowMultiplayerDialog() async {
    final isMultiplayer = ref.read(isMultiplayerProvider);
    if (isMultiplayer && !multiplayerDialogShown) {
      multiplayerDialogShown = true;
      try {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: VikingTheme.dialogBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Multiplayer',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: VikingTheme.accentYellow,
                fontFamily: 'RuneFont',
              ),
            ),
            content: Text(
              'Host or Join a game?',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: VikingTheme.bodyText),
            ),
            actions: [
              _buildMultiplayerButton(context, 'Host', _hostGame),
              _buildMultiplayerButton(context, 'Join', _joinGame),
            ],
          ),
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            connectionStatus = 'Multiplayer dialog error: $e';
            isConnecting = false;
          });
        }
      }
    }
  }

  Widget _buildMultiplayerButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: VikingTheme.accentYellow,
        backgroundColor: VikingTheme.buttonBackground,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: VikingTheme.buttonText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _hostGame() async {
    try {
      setState(() {
        isConnecting = true;
        connectionStatus = 'Hosting...';
      });

      final sessionId = await Networking.createSession();
      final ip = await Networking.getLocalIp();
      await Networking.advertiseSession(sessionId, ip);
      channel = Networking.connectToHost(ip, sessionId);
      isHost = true;
      _listenToChannel();

      if (mounted) {
        setState(() {
          connectionStatus = 'Session hosted. Waiting for players...';
        });
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          connectionStatus = 'Failed to host: $e';
          isConnecting = false;
        });
      }
    }
  }

  Future<void> _joinGame() async {
    try {
      setState(() {
        isConnecting = true;
        connectionStatus = 'Searching for sessions...';
      });

      final sessions = await Networking.discoverSessions();
      if (sessions.isNotEmpty) {
        channel = Networking.connectToHost(sessions.first, '');
        isHost = false;
        _listenToChannel();

        if (mounted) {
          setState(() {
            connectionStatus = 'Joined session.';
          });
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          setState(() {
            connectionStatus = 'No sessions found.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          connectionStatus = 'Failed to join: $e';
          isConnecting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/games/liars_dice/icon.jpg',
              height: 36,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.casino, size: 36),
            ),
            const SizedBox(width: 12),
            Text(
              "Liar's Dice",
              style: theme.textTheme.headlineMedium?.copyWith(
                color: VikingTheme.titleText,
                fontFamily: 'RuneFont',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/common/longship_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      _buildStatusMessage(gameState, theme),
                      _buildCounters(gameState, theme),
                      _buildPlayerDice(gameState, theme),
                      _buildAIDice(gameState, theme),
                      _buildBidHistory(gameState, theme),
                      _buildGameControls(gameState, theme),
                      if (isConnecting)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            connectionStatus ?? '',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: VikingTheme.accentYellow,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Fixed bottom section for multiplayer toggle
              buildToggle(
                context,
                ref,
                ref.watch(isMultiplayerProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessage(GameState gameState, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        gameState.statusMessage,
        style: theme.textTheme.titleLarge?.copyWith(
          color: VikingTheme.accentYellow,
        ),
      ),
    );
  }

  Widget _buildCounters(GameState gameState, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCounterDisplay('You', gameState.playerCounters, theme, isHighlighted: gameState.currentTurn == 'player'),
          _buildCounterDisplay('AI', gameState.aiCounters, theme, isHighlighted: gameState.currentTurn == 'ai'),
        ],
      ),
    );
  }

  Widget _buildCounterDisplay(String label, int count, ThemeData theme, {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isHighlighted
            ? VikingTheme.accentYellow.withValues(alpha: 0.2)
            : VikingTheme.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? VikingTheme.accentYellow : VikingTheme.bodyText.withValues(alpha: 0.3),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shield,
            color: isHighlighted ? VikingTheme.accentYellow : VikingTheme.bodyText,
            size: 24,
          ),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: VikingTheme.bodyText,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            count.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: VikingTheme.accentYellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidHistory(GameState gameState, ThemeData theme) {
    if (gameState.bidHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: VikingTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bid History:',
              style: theme.textTheme.titleMedium?.copyWith(
                color: VikingTheme.bodyText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: gameState.bidHistory.length,
                itemBuilder: (context, index) {
                  final bid = gameState.bidHistory[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: VikingTheme.inputBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: VikingTheme.accentYellow.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          bid['player'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: VikingTheme.accentYellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bid['rank'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: VikingTheme.bodyText,
                          ),
                        ),
                        Text(
                          'Face: ${bid['face']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: VikingTheme.bodyText,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerDice(GameState gameState, ThemeData theme) {
    return Card(
      color: VikingTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your Dice:',
              style: theme.textTheme.titleMedium?.copyWith(
                color: VikingTheme.bodyText,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  gameState.playerDice.length,
                  (index) => DiceWidget(
                    value: gameState.playerDice[index],
                    isHeld: gameState.holds[index],
                    onTap: () =>
                        ref.read(gameStateProvider.notifier).toggleHold(index),
                    size: 80,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIDice(GameState gameState, ThemeData theme) {
    // Show AI dice in different states:
    // 1. During challenge or game over: show actual dice
    // 2. When AI has declared: show hidden dice (question marks)
    // 3. Otherwise: don't show

    final shouldShowCard = gameState.showAiDice ||
                        gameState.phase == 'game_over' ||
                        gameState.declaredRank != null;

    if (!shouldShowCard) {
      return const SizedBox.shrink();
    }

    return Card(
      color: VikingTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'AI Dice:',
              style: theme.textTheme.titleMedium?.copyWith(
                color: VikingTheme.bodyText,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  gameState.aiDice.length,
                  (index) => _buildAIDiceWidget(
                    gameState,
                    index,
                    theme,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIDiceWidget(GameState gameState, int index, ThemeData theme) {
    // Show actual dice during challenge or game over
    if (gameState.showAiDice || gameState.phase == 'game_over') {
      return DiceWidget(
        value: gameState.aiDice[index],
        isHeld: false,
        onTap: () {},
        size: 80,
      );
    }

    // Show hidden dice (question marks) when AI has declared
    if (gameState.declaredRank != null) {
      return Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/common/dice_background.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: VikingTheme.bodyText.withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        child: Center(
          child: Text(
            '?',
            style: TextStyle(
              color: VikingTheme.accentYellow,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Fallback - shouldn't reach here
    return const SizedBox.shrink();
  }

  Widget buildToggle(BuildContext context, WidgetRef ref, bool isMultiplayer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SwitchListTile(
        title: const Text(
          'Multiplayer Mode',
          style: TextStyle(fontFamily: 'RuneFont', color: Colors.amberAccent),
        ),
        value: isMultiplayer,
        onChanged: (value) {
          ref.read(isMultiplayerProvider.notifier).state = value;
        },
        activeColor: Colors.brown[700],
        thumbIcon: WidgetStateProperty.all(Icon(Icons.sports_esports)),
      ),
    );
  }

  Widget _buildGameControls(GameState gameState, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            if (gameState.currentTurn == 'player' && !gameState.showAiDice && gameState.declaredRank == null) ...[
              // Show rank and face dropdowns only after dice are rolled (when roll is disabled)
              if (!gameState.rollButtonEnabled) ...[
                // Rank Selector
                Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: VikingTheme.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: VikingTheme.accentYellow, width: 2),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedRank,
                    hint: Text(
                      'Select Rank',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: VikingTheme.accentYellow,
                      ),
                    ),
                    dropdownColor: VikingTheme.cardBackground,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: VikingTheme.accentYellow,
                    ),
                    underline: Container(),
                    items: PokerHandRank.values
                        .map(
                          (rank) => DropdownMenuItem(
                            value: rank.name,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    rank.name,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: VikingTheme.accentYellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                LiarsDiceHelpers.sampleDiceForRank(
                                  context,
                                  rank.name,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => selectedRank = value),
                  ),
                ),

                // Face Value Selector
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: VikingTheme.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: VikingTheme.accentYellow, width: 2),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedFaceValue,
                    hint: Text(
                      'Select Face',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: VikingTheme.accentYellow,
                      ),
                    ),
                    dropdownColor: VikingTheme.cardBackground,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: VikingTheme.accentYellow,
                    ),
                    underline: Container(),
                    items: List.generate(
                      6,
                      (i) => DropdownMenuItem(
                        value: (i + 1).toString(),
                        child: Text(
                          LiarsDiceHelpers.faceToString(i + 1),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: VikingTheme.accentYellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) => setState(() => selectedFaceValue = value),
                  ),
                ),

                // Declaration Button (only when both rank and face are selected)
                if (selectedRank != null && selectedFaceValue != null) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(gameStateProvider.notifier).declare(
                            selectedRank!,
                            int.parse(selectedFaceValue!),
                          );
                          setState(() {
                            selectedRank = null;
                            selectedFaceValue = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VikingTheme.buttonBackground,
                          foregroundColor: VikingTheme.buttonText,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text('Declare'),
                      ),
                    ),
                  ),
                ],
              ],

              // Roll Button (only show when it's player's turn and rolling is enabled)
              if (gameState.rollButtonEnabled) ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () => ref.read(gameStateProvider.notifier).rollDice(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VikingTheme.buttonBackground,
                        foregroundColor: VikingTheme.buttonText,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Roll Dice'),
                    ),
                  ),
                ),
              ],
            ],

            // Accept/Challenge Buttons (when AI has declared)
            if (gameState.currentTurn == 'player' && gameState.declaredRank != null) ...[
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.read(gameStateProvider.notifier).acceptDeclaration();
                        _scrollToTop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VikingTheme.buttonBackground,
                        foregroundColor: VikingTheme.buttonText,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Accept'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(gameStateProvider.notifier).challenge();
                        _scrollToTop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VikingTheme.errorBackground,
                        foregroundColor: VikingTheme.buttonText,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Challenge'),
                    ),
                  ],
                ),
              ),
            ],

            // Start New Round Button (after challenge resolution)
            if (gameState.showNewRoundButton) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(gameStateProvider.notifier).startNewRound();
                      _scrollToTop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VikingTheme.accentYellow,
                      foregroundColor: VikingTheme.buttonText,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Start New Round'),
                  ),
                ),
              ),
            ],

            // Play Again Button (when game is over)
            if (gameState.phase == 'game_over') ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(gameStateProvider.notifier).restartGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VikingTheme.successBackground,
                      foregroundColor: VikingTheme.buttonText,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Play Again'),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
  }
}
