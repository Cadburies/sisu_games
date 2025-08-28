// lib/games/liars_dice/help_screen.dart
import 'package:flutter/material.dart';
import '../../common/theme.dart'; // Assuming VikingTheme is exported here
import '../../common/ui_helpers.dart';

class LiarsDiceHelpScreen extends StatelessWidget {
  const LiarsDiceHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liar\'s Dice Lore',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: VikingTheme.theme.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/common/stormy_fjord.jpg',
            ), // Add Viking-themed background asset
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ahoy, ye hardy Viking sailors!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gather \'round the longship\'s campfire, me hearties, for a tale of bluff and bone-rolling in Liar\'s Dice! By Odin\'s beard, this be a game where ye roll five rune-etched dice to forge poker hands mighty as Thor\'s hammer—from Five of a Kind down to the lowly High Die. Declare yer rank and face value (Ace be the highest, Nine the scurviest), but speak true or bluff bold, for a challenge from yer foes could send a counter sinkin\' to the fjord\'s depths. Last warrior with counters standin\' claims victory o\'er the seas!',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              Text(
                'How to Sail the Multiplayer Seas',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              _buildStep(
                context,
                '1. Toggle to Multiplayer Mode: Flip the Viking axe switch on the main deck to gather yer crew via local WiFi—no need for the vast internet oceans!',
              ),
              _buildStep(
                context,
                '2. Host or Join a Raid: As host, ye create the session and await yer mates. As joiner, seek out the host\'s longship signal and board!',
              ),
              _buildStep(
                context,
                '3. Roll Yer Bones: Each player rolls five dice in secret. The one with the highest poker hand starts the bidding.',
              ),
              _buildStep(
                context,
                '4. Declare Yer Bid: On yer turn, declare a hand rank and face value higher than the last—or challenge if ye smell a bluff!',
              ),
              _buildStep(
                context,
                '5. Accept or Challenge: If acceptin\', declare higher and pass the raven. If challengin\', reveal the dice! Wrong challenger or bluffer loses a counter.',
              ),
              _buildStep(
                context,
                '6. Victory: Play \'til but one sailor holds counters. That be the king of the fjords!',
              ),
              const SizedBox(height: 24),
              Text(
                'A Saga with Three Warriors',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Picture this, ye swabs: Erik (Player 1), Freya (Player 2), and Bjorn (Player 3) huddle on the longship. All start with 10 counters.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              _buildExampleStep(
                context,
                'Erik rolls first and declares "One Pair of Kings". Freya, sniffin\' no bluff, accepts and declares "Two Pair of Queens".',
              ),
              _buildExampleStep(
                context,
                'Bjorn challenges Freya! Dice reveal: Freya has only One Pair. Bjorn wins the challenge—Freya loses a counter (now 9).',
              ),
              _buildExampleStep(
                context,
                'Round resets. Bjorn starts, declarin\' "Three of a Kind Aces". Erik accepts, bids "Full House Jacks over Tens". Freya challenges Erik—reveal shows Erik bluffin\'! Freya correct, Erik down to 9 counters.',
              ),
              _buildExampleStep(
                context,
                'And so the bluffin\' sails on \'til one claims the hoard!',
              ),
              const SizedBox(height: 16),
              UIHelpers.actionButton(
                context,
                'Back to the Deck',
                () => Navigator.pop(context),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.anchor,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ), // Nautical motif
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleStep(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ), // Viking shield
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
