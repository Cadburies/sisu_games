import 'package:flutter/material.dart';
import 'logic.dart';

class LiarsDiceScreen extends StatefulWidget {
  const LiarsDiceScreen({super.key});

  @override
  State<LiarsDiceScreen> createState() => _LiarsDiceScreenState();
}

class _LiarsDiceScreenState extends State<LiarsDiceScreen> {
  final LiarDiceLogic logic = LiarDiceLogic();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController faceController = TextEditingController();
  String message = '';
  bool showDice = false;

  @override
  void initState() {
    super.initState();
    logic.rollDice();
  }

  void _rollDice() {
    setState(() {
      logic.rollDice();
      showDice = false;
      message = '';
      quantityController.clear();
      faceController.clear();
    });
  }

  void _submitBid() {
    int? quantity = int.tryParse(quantityController.text);
    int? face = int.tryParse(faceController.text);
    if (quantity == null || face == null || face < 1 || face > 6) {
      setState(() {
        message = 'Enter valid quantity and face (1-6).';
      });
      return;
    }
    if (!logic.canBid(quantity, face)) {
      setState(() {
        message = 'Bid must be higher than previous.';
      });
      return;
    }
    setState(() {
      logic.bid(quantity, face);
      message = 'You bid $quantity x $face.';
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      final ai = logic.aiBid();
      setState(() {
        message = 'AI bids ${ai['quantity']} x ${ai['face']}.';
      });
    });
  }

  void _challenge() {
    setState(() {
      showDice = true;
      bool success = logic.challenge();
      if (logic.winner != null) {
        message = logic.winner == 'User' ? 'Victory! 🏆' : 'Defeat! 💀';
      } else {
        message = success
            ? 'Bid was true! Loser loses a die.'
            : 'Bid was false! Bidder loses a die.';
      }
    });
  }

  void _reset() {
    setState(() {
      logic.reset();
      logic.rollDice();
      showDice = false;
      message = '';
      quantityController.clear();
      faceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Liar\'s Dice',
          style: TextStyle(fontFamily: 'RuneFont'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Your Dice (${logic.userDiceCount}):',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (showDice || logic.userTurn)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: logic.userDice
                            .map(
                              (d) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/games/liars_dice/dice_$d.png',
                                  height: 40,
                                  errorBuilder: (c, e, s) => Icon(Icons.casino),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    else
                      const Text(
                        'Hidden',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'AI Dice (${logic.aiDiceCount}):',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (showDice)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: logic.aiDice
                            .map(
                              (d) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/games/liars_dice/dice_$d.png',
                                  height: 40,
                                  errorBuilder: (c, e, s) => Icon(Icons.casino),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    else
                      const Text(
                        'Hidden',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (logic.winner == null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Qty'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: faceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Face'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: logic.userTurn ? _submitBid : null,
                    child: const Text('Bid'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: !logic.userTurn ? _challenge : null,
                    child: const Text('Challenge'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _rollDice,
                child: const Text('Roll Dice'),
              ),
            ],
            if (logic.winner != null)
              ElevatedButton(
                onPressed: _reset,
                child: const Text('Play Again'),
              ),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
