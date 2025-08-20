import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import '../../common/networking.dart';
import '../../common/opening_screen.dart';
import '../../common/ui_helpers.dart';
import 'helpers.dart';
import 'logic.dart';

class LiarsDiceScreen extends ConsumerStatefulWidget {
  const LiarsDiceScreen({super.key});

  @override
  ConsumerState<LiarsDiceScreen> createState() => _LiarsDiceScreenState();
}

class _LiarsDiceScreenState extends ConsumerState<LiarsDiceScreen> {
  final CommonHandLiarDiceLogic logic = CommonHandLiarDiceLogic();
  String message = '';
  bool showDice = false;
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
    logic.determineFirstPlayer();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeShowMultiplayerDialog(),
    );
  }

  void _maybeShowMultiplayerDialog() async {
    final isMultiplayer = ref.read(isMultiplayerProvider);
    if (isMultiplayer && !multiplayerDialogShown) {
      multiplayerDialogShown = true;
      try {
        final result = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Multiplayer',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            content: Text(
              'Host or Join a game?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () async {
                  try {
                    if (mounted) {
                      setState(() {
                        isConnecting = true;
                        connectionStatus = 'Hosting...';
                      });
                    }
                    final sessionId = await Networking.createSession();
                    final ip = await Networking.getLocalIp();
                    await Networking.advertiseSession(sessionId, ip);
                    channel = Networking.connectToHost(ip, sessionId);
                    isHost = true;
                    _listenToChannel();
                    if (mounted) {
                      setState(() {
                        connectionStatus =
                            'Session hosted. Waiting for players...';
                      });
                    }
                    Navigator.of(dialogContext).pop('host');
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        connectionStatus = 'Failed to host: $e';
                      });
                    }
                  }
                },
                child: Text(
                  'Host',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () async {
                  try {
                    if (mounted) {
                      setState(() {
                        isConnecting = true;
                        connectionStatus = 'Searching for sessions...';
                      });
                    }
                    final sessions = await Networking.discoverSessions();
                    if (sessions.isNotEmpty) {
                      channel = Networking.connectToHost(sessions.first, '');
                      isHost = false;
                      _listenToChannel();
                      if (mounted) {
                        setState(() {
                          connectionStatus = 'Joined session.';
                        });
                      }
                    } else {
                      if (mounted) {
                        setState(() {
                          connectionStatus = 'No sessions found.';
                        });
                      }
                    }
                    Navigator.of(dialogContext).pop('join');
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        connectionStatus = 'Failed to join: $e';
                      });
                    }
                  }
                },
                child: Text(
                  'Join',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
        if (mounted) {
          setState(() {
            isConnecting = false;
          });
        }
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

  void _listenToChannel() {
    if (channel == null) return;
    channel!.stream.listen((data) {
      final state = MultiplayerLiarDiceState.fromJson(jsonDecode(data));
      if (mounted) {
        setState(() {
          logic.userCounters = state.playerDiceCount;
          logic.aiCounters = state.opponentDiceCount;
          logic.bidHistory = state.bidHistory;
          logic.userTurn = state.playerTurn;
          logic.winner = state.winner;
        });
      }
    });
  }

  void _sendState() {
    if (channel == null) return;
    final state = MultiplayerLiarDiceState(
      playerDiceCount: logic.userCounters,
      opponentDiceCount: logic.aiCounters,
      bidHistory: logic.bidHistory,
      playerTurn: logic.userTurn,
      winner: logic.winner,
    );
    Networking.send(channel!, state.toJson());
  }

  void _rollDice() {
    if (mounted) {
      setState(() {
        logic.rollDice();
        showDice = false;
        message = '';
        selectedRank = null;
        selectedFaceValue = null;
      });
    }
    _sendState();
  }

  void _submitBid() {
    if (selectedRank == null || selectedFaceValue == null) {
      if (mounted) {
        setState(() {
          message = 'Please select a rank and face value.';
        });
      }
      return;
    }
    final rank = PokerHandRank.values.firstWhere(
      (r) => r.name == selectedRank!.split(' ')[0].toLowerCase(),
    );
    final faceValue = int.parse(selectedFaceValue!.split('=')[0]);
    if (!logic.canDeclare(rank, faceValue)) {
      if (mounted) {
        setState(() {
          message = 'Must declare a higher hand rank or face value.';
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        logic.declareHand(rank, faceValue);
        message =
            'You declared ${rank.name} of ${LiarsDiceHelpers.faceToString(faceValue)}.';
        if (!logic.userTurn) _aiTurn();
      });
    }
    _sendState();
  }

  void _challenge() {
    if (mounted) {
      setState(() {
        showDice = true;
        bool success = logic.challenge();
        if (logic.winner != null) {
          message = logic.winner == 'User' ? 'Victory! 🏆' : 'Defeat! 💀';
        } else {
          message = success
              ? 'Challenge correct! Last player loses a counter.'
              : 'Challenge failed! Challenger loses a counter.';
        }
        logic.userTurn = true; // Return to player after challenge
      });
    }
    _sendState();
  }

  void _accept() {
    if (mounted) {
      setState(() {
        message = 'You accepted the AI\'s declaration. Next player\'s turn.';
        logic.userTurn = true; // Return to player after acceptance
      });
    }
    _sendState();
  }

  void _aiTurn() async {
    if (mounted) {
      setState(() {
        message = 'AI is thinking...';
      });
      await Future.delayed(const Duration(seconds: 2)); // Simulate AI thinking
      final lastBid = logic.bidHistory.isNotEmpty
          ? logic.bidHistory.last
          : {'rank': 8, 'faceValue': 1}; // Default to lowest if no prior bid
      int newRankIndex = lastBid['rank']! - 1;
      int newFaceValue = lastBid['faceValue']!;
      if (newRankIndex < 0) {
        newRankIndex = lastBid['rank']!;
        newFaceValue = min(6, lastBid['faceValue']! + 1);
      }
      final rank = PokerHandRank.values[newRankIndex];
      logic.declareHand(rank, newFaceValue);
      if (mounted) {
        setState(() {
          message =
              'AI declared ${rank.name} of ${LiarsDiceHelpers.faceToString(newFaceValue)}.';
        });
      }
      _sendState();
      // Show accept/challenge options for player
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'AI\'s Declaration',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Text(
            'Accept or challenge ${rank.name} of ${LiarsDiceHelpers.faceToString(newFaceValue)}?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _accept();
              },
              child: Text(
                'Accept',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _challenge();
              },
              child: Text(
                'Challenge',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _reset() {
    if (mounted) {
      setState(() {
        logic.reset();
        showDice = false;
        message = '';
        selectedRank = null;
        selectedFaceValue = null;
      });
    }
    _sendState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeShowMultiplayerDialog(),
    );
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
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/common/longship_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UIHelpers.playerStatus(
                    'Player',
                    logic.userCounters,
                    isActive: logic.userTurn,
                  ),
                  const SizedBox(height: 8),
                  if (showDice || logic.userTurn)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  logic.toggleDiceHold(index);
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: logic.userDiceHold[index]
                                    ? Colors.green.withValues(alpha: 0.5)
                                    : Colors.grey.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                LiarsDiceHelpers.cardFaceAssetForDie(
                                  logic.userDice[index],
                                ),
                                height: 55,
                                errorBuilder: (c, e, s) =>
                                    Icon(Icons.casino, size: 55),
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  else
                    const Text(
                      'Hidden',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  const SizedBox(height: 8),
                  UIHelpers.playerStatus(
                    'AI',
                    logic.aiCounters,
                    isActive: !logic.userTurn,
                  ),
                  if (showDice)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: logic.aiDice
                            .map(
                              (d) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  LiarsDiceHelpers.cardFaceAssetForDie(d),
                                  height: 55,
                                  errorBuilder: (c, e, s) =>
                                      Icon(Icons.casino, size: 55),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  else
                    const Text(
                      'Hidden',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  const SizedBox(height: 16),
                  if (logic.winner == null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UIHelpers.themedDropdown<String>(
                          value: selectedRank,
                          items: PokerHandRank.values.reversed.map((rank) {
                            return DropdownMenuItem<String>(
                              value:
                                  '${rank.name} (Rank ${PokerHandRank.values.length - rank.index})',
                              child: Text(
                                '${rank.name} (Rank ${PokerHandRank.values.length - rank.index})',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (mounted) setState(() => selectedRank = value);
                          },
                          hint: 'Select Rank',
                          context: context,
                        ),
                        const SizedBox(width: 8),
                        UIHelpers.themedDropdown<String>(
                          value: selectedFaceValue,
                          items:
                              [
                                    '1=Ace',
                                    '2=Queen',
                                    '3=Jack',
                                    '4=King',
                                    '5=Ten',
                                    '6=King of Spades',
                                  ]
                                  .map(
                                    (face) => DropdownMenuItem<String>(
                                      value: face,
                                      child: Text(
                                        face,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (mounted)
                              setState(() => selectedFaceValue = value);
                          },
                          hint: 'Select Face',
                          context: context,
                        ),
                        const SizedBox(width: 8),
                        UIHelpers.actionButton(
                          'Declare',
                          () => logic.userTurn ? _submitBid() : null,
                        ),
                        const SizedBox(width: 8),
                        UIHelpers.actionButton(
                          'Challenge',
                          () => !logic.userTurn ? _challenge() : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    UIHelpers.actionButton('Roll Dice', _rollDice),
                  ],
                  if (logic.winner != null)
                    UIHelpers.actionButton('Play Again', _reset),
                  const SizedBox(height: 16),
                  if (isConnecting)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        connectionStatus ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  UIHelpers.statusBanner(message),
                  const SizedBox(height: 16),
                  buildToggle(context, ref, ref.watch(isMultiplayerProvider)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
