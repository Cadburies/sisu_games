Document Title: Project Requirement Document (PRD) for 'Sisu Games'

Date: August 20, 2025

Time: 06:25 AM EDT

Author: AI-Generated (based on Frik Olivier's input)

Version: 2.0

1. Project Overview
   Project Name: Sisu Games

Description: Sisu Games is a mobile application built with Flutter and Dart, designed to immerse players in ancient Norse seafarer culture through a collection of classic multiplayer and single-player games. The app features a Viking-themed aesthetic with weathered wood textures, rune carvings, longships, stormy fjords, shields, axes, and nautical motifs across all visuals and UI elements. It supports local WiFi multiplayer (no internet required) using peer-to-peer or host-client setups, with animations for turn passing (e.g., raven flight).

Objective:

Deliver an engaging, culturally rich gaming experience.
Support a variety of games with single-player AI and local multiplayer via WiFi.
Adhere to modern Flutter best practices for scalability and testing.

Target Audience: Mobile gamers (13+), fans of historical/themed games, and casual players seeking offline multiplayer.

Platform: Android (API 36, NDK 27.0.12077973), iOS (iOS 13.0+).

2. Project Scope
   2.1 In-Scope

Core Games: Initial release includes Liar's Dice (Common Hand variant), Poker, and Solitaire, with plans to add Backgammon (Hnefatafl), Checkers (Viking Chess), Yatzy, Uno, and Cribbage.
Multiplayer: Local WiFi using multicast_dns, network_info_plus, and web_socket_channel for real-time sync.
Single-Player: AI opponents with adjustable difficulty.
UI/UX: Viking-themed design with customizable backgrounds, rune-etched icons, and animated transitions.
Features:

Opening screen with a Viking longship deck or campfire background and a grid of game icons.
Single/multiplayer toggle styled as a Viking axe.
Turn-based networked play with visual cues (e.g., raven animations).
Responsive design for various screen sizes.

Development Tools: Flutter SDK (3.32.8+), Dart SDK (3.8.1+), Visual Studio Code, Git.

2.2 Out-of-Scope

Online multiplayer requiring internet.
Advanced 3D graphics beyond 2D animations.
In-app purchases or monetization (initial release).
Non-mobile platforms (e.g., desktop, web beyond basic testing).

3. Functional Requirements
   3.1 User Interface

Opening Screen: Viking longship deck or campfire background, grid layout of themed game icons (e.g., rune-carved card for Poker, bone dice for Liar's Dice), Viking axe-styled toggle for single/multiplayer mode.
Game Screens: Dedicated screens with Viking-themed backgrounds (e.g., plank-wood table), interactive elements with rune designs, runic font (NotoSansRunic-Regular.ttf).
Navigation: Tap icons to launch game screens, back navigation returns to opening screen.

3.2 Gameplay

Liar's Dice (Common Hand): Liar's Dice is known by many names, such as Doubting Dice, Dudo, Perudo, Mexacali, Call My Bluff, "pirate's dice," "deception dice," and so on. Uses Poker Dice hands (Five of a Kind to Highest Single Number), 10 counters per player, first player determined by highest hand, players declare rank and face value, challenge resolves with counter loss, last player with counters wins.
Poker: Texas Hold'em with 2 hole cards, 5 community cards, betting rounds, bluffing.
Solitaire: Klondike variant with card arrangement and foundation piles.
Additional Games:
Backgammon (Hnefatafl): Defender protects king, attackers capture.
Checkers (Viking Chess): Diagonal moves, captures, king promotion.
Yatzy: Roll 5 dice for category scores.
Uno: Match cards by color/number with special actions.
Cribbage: Card play with peg scoring on a board.

Modes: Single-player with AI, multiplayer via local WiFi.

3.3 Technical Requirements

State Management: Use Provider or Riverpod.
Theme: Custom ThemeData with Viking fonts, deep blues, earthy browns, metallic grays. Put all theme/style related GUI in theme.dart if not already in lib/common/theme.dart and use it for example, in the screen.dart then as for example, "Theme.of(context).textTheme.headlineMedium"
Testing: Unit tests for game logic, integration tests for multiplayer.
Version Control: Git with branches per game/feature.
Libraries: flame for game elements if needed, firebase only for cloud (avoid initially), local WiFi packages.

4. Detailed Requirements Table

Requirement IDDescriptionUser StoryExpected Behavior/OutcomeREQ-001Implement Opening ScreenAs a user, I want a Viking-themed dashboard to select games.Displays a longship deck/campfire background, a grid of themed icons, and a Viking axe toggle for single/multiplayer mode.REQ-002Support Local WiFi MultiplayerAs a player, I want to play with others via local WiFi.Devices discover and connect using multicast_dns and web_socket_channel, sync game state in real-time, with raven animations for turn passing.REQ-003Develop Game ModulesAs a developer, I want modular game code for scalability.Each game (e.g., Liar's Dice, Poker) has separate lib/games/[game_name]/ and assets/games/[game_name]/ folders.REQ-004Enforce Viking ThemeAs a designer, I want a consistent Viking aesthetic.All UI elements use ThemeData with rune fonts, weathered wood colors, and nautical motifs, confirmed by visual inspection.REQ-005Implement TestingAs a developer, I want to ensure game reliability.Unit tests cover game logic, integration tests verify multiplayer sync, with 90%+ coverage.REQ-006Develop Liar's Dice GameAs a player, I want to play Liar's Dice with Viking twists.Game follows "Common Hand" rules with poker hands, 10 counters, and face value declarations, playable in single/multiplayer modes.
Sub-Requirements for REQ-006 (Liar's Dice)

5. Detailed Requirements Table for Liar's Dice Single Player
   Sub-Requirement ID Description User Story detailed implementation
   REQ-007-001 Display initial UI for determining starter As a player, I want to see both sets of dice before rolling to determine the starter. In lib/games/liars*dice/screen.dart, use Riverpod's StateNotifierProvider to manage game state in a GameStateNotifier class defined in lib/games/liars_dice/logic.dart. The state includes properties like phase: 'determine_starter', playerDice: List<int>.empty(), aiDice: List<int>.empty(), statusMessage: 'Roll dice to determine who start', rollButtonEnabled: true. In the ConsumerWidget build method, if phase == 'determine_starter', render a Column with two Rows: one for Player's dice (5 DiceWidget from lib/common/ui_helpers.dart, styled with Viking bone textures from assets/games/liars_dice/dice_face*{1-6}.png, using Image.asset with BoxFit.contain), similarly for AI's dice below it, both visible. Use Theme.of(context).colorScheme.surface for background with overlay weathered wood texture. Display statusMessage with Theme.of(context).textTheme.bodyLarge.copyWith(fontFamily: 'NotoSansRunic', color: Theme.of(context).colorScheme.primary). Add ElevatedButton(styled with Theme.of(context).elevatedButtonTheme, icon: Icon(Icons.casino, color: Theme.of(context).colorScheme.secondary), label: Text('Roll Dice', style: Theme.of(context).textTheme.labelLarge), onPressed: if rollButtonEnabled, call notifier.rollToDetermineStarter()).</int></int>
   REQ-007-002 Roll dice to determine starter As a player, I want a fair and visual roll to decide who starts. In GameStateNotifier.rollToDetermineStarter(), disable rollButton, simulate rolling animation by updating state with random dice values every 200ms for 2-3 seconds using Timer.periodic, then stop on final random values (List<int> with 5 values 1-6 using math.Random). Compute ranks using calculateHandRankAndFace(dice) from lib/games/liars_dice/helpers.dart (define function to evaluate poker hand rank 1-8 and face value). Compare playerRank/playerFace vs aiRank/aiFace using isHigher(rank1, face1, rank2, face2). Set startingTurn to 'player' or 'ai' based on higher, phase to 'gameplay', currentTurn to startingTurn, currentDice to [], currentBid to null, statusMessage to '${startingTurn.capitalize()} starts the game', playerDice and aiDice cleared.</int>
   REQ-007-003 Display Player's turn UI for rolling As a player, I want to prepare and roll dice on my turn. If currentTurn == 'player' and phase == 'gameplay', show currentDice (visible to player, List of 5 DiceWidget, initially empty/placeholders if first turn, else transferred from previous). Allow tapping each DiceWidget to toggle hold state (state.holds List<bool>, green border for hold, gray for roll, update via notifier.toggleHold(index)). Status message "Roll Dice", roll button enabled. Use GestureDetector on each dice for toggle. If first turn, all gray (no hold). Background stormy sea with longship motif from Theme.of(context).</bool>
   REQ-007-004 Toggle hold for player's dice As a player, I want to select which dice to hold or re-roll. In DiceWidget, use StatefulWidget with hold bool, onTap: notifier.toggleHold(index), update color: hold ? Colors.green.withValues(alpha:0.5) : Colors.grey.withValues(alpha:0.5), border accordingly. Notifier updates holds list in state.
   REQ-007-005 Roll dice for player As a player, I want to roll non-held dice and proceed to declare. On roll button press, if enabled, animate rolling for non-held (gray) dice, generate new random 1-6 for those positions, update currentDice, disable roll button, enable dropdowns for rank (DropdownButton<int> 1-9, items from handRanks.keys mapped to values) and face (1-6), status "Select Rank and Face". Use Future.delayed for animation simulation. Validate declare must be higher than currentBid if exists, but enable anyway (validate on declare).</int>
   REQ-007-006 Select rank and face for declare As a player, I want to choose my declaration after rolling. Use two DropdownButton in Row, styled with Theme.of(context).inputDecorationTheme, onChanged: notifier.setSelectedRank(value), notifier.setSelectedFace(value). Declare button disabled until both selected != null.
   REQ-007-007 Declare bid for player As a player, I want to submit my declaration if valid. On declare button press, validate if selectedRank/Face > currentBid (using isHigher), if not show snackbar error with Theme.of(context).colorScheme.error. If yes or no currentBid, set currentBid to {rank: selectedRank, face: selectedFace}, reset selected to null, dropdowns disabled, set currentTurn to 'ai', status "AI's turn".

6. Development Approach

Focus: Develop one game at a time (start with Liar's Dice), iterate from basic UI to full multiplayer.
Iteration: Allow switching games mid-development as requested.
Assets: Generate Viking-themed images/icons on demand (confirm before generating).
Structure: Use modular monorepo with:

6.1. lib/common/ for shared code, including:

card_logic_helpers.dart contains all the common helper functions for card logic.
logic_helpers.dart contains all the common helper functions for game logic.
networking.dart contains all the common helper functions for networking logic.
ui_helpers.dart contains all the common helper functions for UI widgets and screens.

6.2. lib/games/[game_name]/ for game-specific logic and screens, including:

helpers.dart contains all the common helper functions for game-specific helpers.
logic.dart contains all the common helper functions for game-specific logic.
screen.dart contains all the common helper functions for the game-specific screen.

6.3. assets/games/[game_name]/ for game assets.
6.4. sisu-games-prd.md contains the Project Requirements Document.

7. Next Steps

Implement Liar's Dice based on sub-requirements.
Expand helpers for Poker, Solitaire, etc., as needed.
Conduct initial testing and adjust based on feedback.
