// lib/games/liars_dice/screen.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

  static const List<String> rankNames = [
    'Five of a Kind',
    'Four of a Kind',
    'Full House',
    'High Straight',
    'Low Straight',
    'Three of a Kind',
    'Two Pair',
    'One Pair',
    'High Die',
  ];

  static const List<String> faceNames = [
    'Ace',
    'King',
    'Queen',
    'Jack',
    'Ten',
    'Nine',
  ];

  static const List<int> faceDiceValues = [6, 5, 4, 3, 2, 1];

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
    Networking.send(channel!, jsonEncode(state.toJson()));
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
    final rankIndex = rankNames.indexOf(selectedRank!);
    final rank = PokerHandRank.values[rankIndex];
    final faceIndex = faceNames.indexOf(selectedFaceValue!);
    final faceValue = faceDiceValues[faceIndex];
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
        logic.userTurn = !logic.userTurn;
      });
    }
    _sendState();
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

  void _aiTurn() {
    // Placeholder for AI logic (assuming it's implemented elsewhere or add here)
    // For example, simulate AI declare after delay
    Timer(const Duration(seconds: 2), () {
      // AI declare logic...
      if (mounted) {
        setState(() {
          // Update state after AI action
        });
      }
      _sendState();
    });
  }

  Widget _buildToggle(BuildContext context, WidgetRef ref, bool isMultiplayer) {
    return SwitchListTile(
      title: Text(
        'Multiplayer Mode',
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontFamily: 'RuneFont'),
      ),
      value: isMultiplayer,
      activeColor: Theme.of(context).iconTheme.color,
      inactiveThumbColor: Colors.grey[700],
      inactiveTrackColor: Colors.grey[900],
      onChanged: (value) {
        ref.read(isMultiplayerProvider.notifier).state = value;
        if (mounted) {
          setState(() {
            multiplayerDialogShown = false; // Reset dialog for next toggle
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liar\'s Dice',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UIHelpers.playerStatus(
                context,
                'User Counters',
                logic.userCounters,
                isActive: logic.userTurn,
              ),
              const SizedBox(height: 8),
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
                                ? Colors.green.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.5),
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
                Text(
                  'Hidden',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              const SizedBox(height: 8),
              UIHelpers.playerStatus(
                context,
                'AI Counters',
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
                Text(
                  'Hidden',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              const SizedBox(height: 16),
              if (logic.winner == null) ...[
                Column(
                  children: [
                    UIHelpers.themedDropdown<String>(
                      value: selectedRank,
                      items: List.generate(PokerHandRank.values.length, (
                        index,
                      ) {
                        final rank = PokerHandRank.values[index];
                        final name = rankNames[index];
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Row(
                            children: [
                              Text(name),
                              const SizedBox(width: 8),
                              LiarsDiceHelpers.sampleDiceForRank(context, name),
                            ],
                          ),
                        );
                      }),
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            selectedRank = value;
                          });
                        }
                      },
                      hint: 'Select Rank',
                      context: context,
                    ),
                    const SizedBox(height: 8),
                    UIHelpers.themedDropdown<String>(
                      value: selectedFaceValue,
                      items: List.generate(faceNames.length, (index) {
                        final name = faceNames[index];
                        final dieValue = faceDiceValues[index];
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Row(
                            children: [
                              Text(name),
                              const SizedBox(width: 8),
                              UIHelpers.vikingDiceFace(
                                context,
                                dieValue,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      }),
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            selectedFaceValue = value;
                          });
                        }
                      },
                      hint: 'Select Face',
                      context: context,
                    ),
                    const SizedBox(height: 8),
                    if (logic.userTurn)
                      UIHelpers.actionButton(context, 'Declare', _submitBid),
                    if (!logic.userTurn)
                      UIHelpers.actionButton(context, 'Challenge', _challenge),
                  ],
                ),
                const SizedBox(height: 8),
                UIHelpers.actionButton(context, 'Roll Dice', _rollDice),
              ],
              if (logic.winner != null)
                UIHelpers.actionButton(context, 'Play Again', _reset),
              const SizedBox(height: 16),
              if (isConnecting)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    connectionStatus ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              UIHelpers.statusBanner(context, message),
              const SizedBox(height: 16),
              _buildToggle(context, ref, ref.watch(isMultiplayerProvider)),
            ],
          ),
        ),
      ),
    );
  }
}
