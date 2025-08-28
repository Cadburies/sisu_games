// lib/games/liars_dice/screen.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../common/dice_widget.dart';
import '../../common/networking.dart';
import '../../common/opening_screen.dart';
import '../../common/theme.dart';
import 'helpers.dart';
import 'models/poker_hand_rank.dart';
import 'state/game_state.dart';
import 'state/game_state_notifier.dart';
import 'state/multiplayer_state.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeShowMultiplayerDialog(),
    );
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
              _buildStatusMessage(gameState, theme),
              _buildPlayerDice(gameState, theme),
              _buildAIDice(gameState, theme),
              const Spacer(),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: buildToggle(
                  context,
                  ref,
                  ref.watch(isMultiplayerProvider),
                ),
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

  Widget _buildGameControls(GameState gameState, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to left
        children: [
          if (gameState.currentTurn == 'player' && !gameState.showAiDice) ...[
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
                isExpanded: true, // Make dropdown take full width
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
                isExpanded: true, // Make dropdown take full width
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

            // Action Buttons - Center these
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ...existing action buttons code...
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
