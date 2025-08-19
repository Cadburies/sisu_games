### Project Requirement Document (PRD) for 'Sisu Games'

**Date**: August 13, 2025  
**Time**: 10:26 AM SAST  
**Author**: Frik Olivier  
**Version**: 1.0

---

#### 1. Project Overview

**Project Name**: Sisu Games  
**Description**: Sisu Games is a mobile application designed to bring the spirit of ancient Norse seafarers to modern gamers through a collection of classic sailor-inspired games with a Viking twist. Built using Flutter and Dart, the app features a modular, multiplayer-focused design, supporting local WiFi connectivity (no internet required) and single-player modes with AI opponents. The app's signature style includes weathered wood textures, rune carvings, longships, stormy fjords, shields, axes, and nautical motifs, permeating all visuals and UI elements.

**Objective**:

- Provide an immersive gaming experience rooted in Viking sailor culture.
- Offer a variety of games adaptable to single-player and local multiplayer via peer-to-peer or host-client setups.
- Leverage modern Flutter best practices for scalability, testing, and performance.

**Target Audience**:

- Mobile gamers aged 13+ interested in strategy, card, and dice games.
- Fans of historical or themed gaming experiences (e.g., Viking/Norse mythology).
- Casual players seeking offline multiplayer options.

**Platform**:

- Android (API 36, NDK 27.0.12077973)
- iOS (iOS 13.0+)

---

#### 2. Project Scope

##### 2.1 In-Scope

- **Core Games**: Initial release includes Poker, Liar's Dice, and Solitaire, with plans to add Backgammon (Hnefatafl), Checkers (Viking Chess), Yatzy, Uno, and Cribbage.
- **Multiplayer**: Local WiFi multiplayer using `multicast_dns`, `network_info_plus`, and `web_socket_channel` for real-time sync.
- **Single-Player**: AI opponents with rule-based logic.
- **UI/UX**: Viking-themed design with customizable backgrounds (e.g., stormy seas, longship decks), rune-etched icons, and animated transitions.
- **Features**:
  - Opening screen with a grid of game icons.
  - Single/multiplayer toggle with Viking-styled switch.
  - Turn-based networked play with visual cues (e.g., raven animations).
  - Responsive design for various screen sizes.
- **Development Tools**: Flutter SDK (3.32.8+), Dart SDK (3.8.1+), Visual Studio Code, Git.

##### 2.2 Out-of-Scope

- Online multiplayer requiring internet connectivity.
- Advanced graphics (e.g., 3D rendering) beyond 2D animations.
- In-app purchases or monetization (initial release).
- Support for non-mobile platforms (e.g., desktop, web beyond basic testing).

---

#### 3. Functional Requirements

##### 3.1 User Interface

- **Opening Screen**:
  - Displays a Viking longship deck or campfire gathering as a background.
  - Grid or circular layout of game icons (e.g., rune-carved card for Poker, bone dice for Liar's Dice).
  - Toggle switch styled as a Viking axe for single/multiplayer mode.
- **Game Screens**:
  - Each game has a dedicated screen with a Viking-themed background (e.g., plank-wood table).
  - Interactive elements (e.g., cards, dice) with rune designs.
  - Clear text using a runic font (NotoSansRunic-Regular.ttf).
- **Navigation**: Tap game icons to launch respective screens; back navigation returns to the opening screen.

##### 3.2 Gameplay

- **Poker**: Texas Hold'em with 2 hole cards, 5 community cards, betting rounds, and bluffing.
- **Liar's Dice**: Roll hidden dice, bid on totals, challenge bluffs; lose dice on incorrect calls.
- **Solitaire**: Klondike variant with card arrangement and foundation piles.
- **Additional Games**:
  - Backgammon (Hnefatafl): Defender protects king, attackers capture.
  - Checkers (Viking Chess): Diagonal moves, captures, king promotion.
  - Yatzy: Roll 5 dice for category scores.
  - Uno: Match cards by color/number with special actions.
  - Cribbage: Card play with peg scoring on a board.
- **Modes**:
  - Single-Player: AI opponents with adjustable difficulty.
  - Multiplayer: Local WiFi host-client or peer-to-peer; turns synced via WebSocket.

##### 3.3 Multiplayer Mechanics

- **Discovery**: Use `multicast_dns` for device discovery on local WiFi.
- **Sync**: `web_socket_channel` for real-time turn and state updates (e.g., dice rolls, card deals).
- **Visualization**: Animated turn passing (e.g., raven flight); player avatars as Viking helmets.
- **Session**: Host creates a game ID; others join via QR code or IP entry.

##### 3.4 Performance and Stability

- **Responsive Design**: Adaptable to various screen sizes and orientations.
- **Performance**: Target 60 FPS for animations; optimize asset loading.
- **Error Handling**: Graceful fallback for missing assets (e.g., `errorBuilder` with icons).

---

#### 4. Non-Functional Requirements

- **Performance**: Load times under 2 seconds; no lag during multiplayer sync.
- **Compatibility**: Android 7.0+ (API 24+), iOS 13.0+.
- **Security**: No sensitive data stored; local WiFi only.
- **Usability**: Intuitive navigation; accessible touch targets (48x48 dp minimum).
- **Maintainability**: Modular monorepo structure (`lib/common/`, `lib/games/`, `assets/games/`).

---

#### 5. Technical Requirements

##### 5.1 Architecture

- **Modular Monorepo**:
  - `lib/common/`: Shared code (theme, networking, widgets).
  - `lib/games/[game_name]/`: Game-specific logic and UI.
  - `assets/common/`: Shared assets (backgrounds, sounds).
  - `assets/games/[game_name]/`: Game-specific assets (icons, boards).
- **State Management**: Riverpod for reactive state (e.g., multiplayer toggle, game state).
- **Networking**: Local WiFi with `multicast_dns` for discovery, `web_socket_channel` for sync.

##### 5.2 Dependencies

- `flutter: sdk: flutter`
- `riverpod: ^2.6.3`
- `web_socket_channel: ^3.0.4`
- `uuid: ^4.5.2`
- `multicast_dns: ^0.3.3`
- `network_info_plus: ^6.1.5`
- `json_annotation: ^4.9.0`
- `cupertino_icons: ^1.0.8`
- `flutter_launcher_icons: ^0.14.4`
- `launcher_name: ^1.0.2`

##### 5.3 Development Environment

- **Flutter SDK**: 3.32.8+
- **Dart SDK**: 3.8.1+
- **IDE**: Visual Studio Code
- **Version Control**: Git
- **Build Tools**: Android Gradle Plugin 8.5.0, Xcode 16.4, CocoaPods 1.16.2+

---

#### 6. Milestones and Deliverables

- **M1: Initial Setup (Completed)**

  - Environment setup, basic project structure, Viking theme, opening screen.
  - Deliverable: Functional app with placeholder screens.

- **M2: Core Games (In Progress)**

  - Implement Poker, Liar's Dice, Solitaire with single-player and multiplayer modes.
  - Deliverable: Playable game screens, basic networking.

- **M3: Additional Games (Future)**

  - Add Backgammon, Checkers, Yatzy, Uno, Cribbage.
  - Deliverable: Expanded game library.

- **M4: Polish and Testing (Future)**

  - Add animations, sound effects, unit/integration tests.
  - Deliverable: Stable release candidate.

- **M5: Release (Future)**
  - Final build, documentation, deployment to app stores.
  - Deliverable: Public release.

---

#### 7. Risks and Mitigation

- **Risk**: Asset loading failures (e.g., missing images).
  - **Mitigation**: Use `errorBuilder` for fallbacks; generate assets early.
- **Risk**: Multiplayer sync delays.
  - **Mitigation**: Test on multiple devices; optimize WebSocket latency.
- **Risk**: Platform compatibility issues.
  - **Mitigation**: Regular `flutter doctor` checks; test on Android/iOS emulators.

---

#### 8. Acceptance Criteria

- App launches to a Viking-themed opening screen with navigable game icons.
- Each game is playable in single-player mode with AI.
- Multiplayer mode connects at least two devices on the same WiFi, syncing turns.
- UI elements are fully visible and interactive in full-screen mode.
- No critical bugs (e.g., crashes) on initial release.

---

#### 9. Appendix

- **References**:
  - Flutter Documentation: https://flutter.dev/docs
  - Viking Games History: Regia Anglorum (https://regia.org/research/games.htm)
  - Multiplayer Networking: https://pub.dev/packages/web_socket_channel
- **Contact**: Frik Olivier (frikolivier@example.com)

- **Requirements for General Game**:
  Requirement ID Description User Story Expected Behavior/Outcome
  REQ-001 Verify current project status and folder structure As a developer, I want to confirm the existing project setup and file organization to ensure a solid foundation for development. The project directory (/Users/frikolivier/vs/sisu_games/) is reviewed using ls -R, confirming the presence of android/, ios/, lib/, assets/, pubspec.yaml, and other standard Flutter files. The lib/ folder contains common/, poker/, liars_dice/, solitaire/, and main.dart; assets/ includes fonts/, common/, games/, and icon/ with expected assets (e.g., NotoSansRunic-Regular.ttf, longship_background.png, icon.jpg). No critical files are missing, and the structure aligns with the modular monorepo design.
  REQ-002 Set up Viking-themed visual identity As a designer, I want a consistent Viking aesthetic to immerse users in a Norse seafarer experience. The app uses a ThemeData in lib/common/theme.dart with primaryColor: Colors.blueGrey[800], scaffoldBackgroundColor: Colors.grey[900], cardColor: Colors.brown[900], and a runic font (RuneFont from assets/fonts/NotoSansRunic-Regular.ttf). UI elements (buttons, cards) feature weathered wood and rune motifs, verified by launching the app and inspecting the opening screen.
  REQ-003 Implement opening screen with game selection As a user, I want an intuitive starting screen to choose my game and mode. The lib/common/opening_screen.dart displays a Scaffold with a GridView of game icons (Poker, Liar's Dice, Solitaire) on a Viking longship deck background (assets/common/longship_background.png). Tapping an icon navigates to the respective game screen, and a Viking axe-styled toggle (SwitchListTile) switches between single-player and multiplayer modes, confirmed by user interaction and navigation.
  REQ-004 Enable full-screen mode with system bar overlay As a user, I want the app to utilize the entire screen for an immersive experience without overlap issues. The main.dart uses SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)and setSystemUIOverlayStyle with transparent colors and light icons. The Scaffold in opening_screen.dart has extendBodyBehindAppBar: true and extendBody: true, ensuring the Viking background fills the screen behind status and navigation bars, verified by launching on SM S928U1 with no content obscured.
  REQ-005 Implement Poker game with single-player mode As a player, I want to play Poker against an AI to practice my skills. The lib/games/poker/screen.dart displays a Scaffold with a Viking-themed table and cards. The lib/games/poker/logic.dart initializes a PokerLogic class with a shuffled deck (VikingSuit, Rank) and AI opponents using rule-based betting (e.g., fold on weak hands). Users can deal, bet, and fold, with outcomes displayed, confirmed by a playable single-player session.
  REQ-006 Implement Poker game with multiplayer mode As a player, I want to play Poker with friends over local WiFi for a social experience. The lib/games/poker/screen.dart supports networked play where the host deals cards via web_socket_channel, and players send bets/actions. Turns pass with a raven animation, and verbal bluffing occurs off-app. Multi-device sync is verified by connecting two devices on the same WiFi, with successful turn transitions.
  REQ-007 Implement Liar's Dice game with single-player mode As a player, I want to play Liar's Dice against an AI to test my bluffing skills. The lib/games/liars_dice/screen.dart shows a Scaffold with a campfire circle and dice. The lib/games/liars_dice/logic.darthandles hidden dice rolls and AI bidding based on probability, allowing users to bid and challenge, confirmed by a playable single-player round.
  REQ-008 Implement Liar's Dice game with multiplayer mode As a player, I want to play Liar's Dice with friends over local WiFi for group fun. The lib/games/liars_dice/screen.dart syncs turns via WebSocket, with players rolling privately and announcing bids verbally. Challenges reveal dice, synced across devices, verified by multiplayer testing with turn passing and bluff resolution.
  REQ-009 Implement Solitaire game with single-player mode As a player, I want to play Solitaire to relax during downtime. The lib/games/solitaire/screen.dart displays a Scaffold with a shield-layout board. The lib/games/solitaire/logic.dart manages card arrangement and offers AI hints, confirmed by a playable single-player game with valid moves.
  REQ-010 Implement Solitaire game with multiplayer mode As a player, I want to compete in Solitaire races with friends over local WiFi. The lib/games/solitaire/screen.dart syncs scores and timed races via WebSocket, with a shared "ghost" play for comparison, verified by multi-device score updates.
  REQ-011 Add Backgammon (Hnefatafl) game support As a player, I want to play a strategic Viking game like Backgammon. The lib/games/backgammon/screen.dart shows a rune-carved shield board, and lib/games/backgammon/logic.dart validates moves, confirmed by a navigable screen from the opening grid.
  REQ-012 Add Checkers (Viking Chess) game support As a player, I want to play a tactical game like Checkers with a Viking twist. The lib/games/checkers/screen.dart displays a plank-wood board, and lib/games/checkers/logic.dart handles jumps, confirmed by navigation and basic play.
  REQ-013 Add Yatzy (Viking Dice Game) game support As a player, I want to enjoy a dice game like Yatzy with a Norse flair. The lib/games/yatzy/screen.dart shows a Viking tablet scorecard, and lib/games/yatzy/logic.dart scores rolls, confirmed by a playable screen.
  REQ-014 Add Uno game support As a player, I want to play a fast card game like Uno with a Viking theme. The lib/games/uno/screen.dart displays rune-tiled cards, and lib/games/uno/logic.dart manages matches, confirmed by navigation.
  REQ-015 Add Cribbage (Adapted with Pegs) game support As a player, I want to play a peg-based card game with a Viking twist. The lib/games/cribbage/screen.dart displays a rune plank board, and lib/games/cribbage/logic.dart counts combinations, confirmed by navigation.
  REQ-016 Implement multiplayer discovery and session creation As a host, I want to create and join multiplayer sessions easily. The lib/common/networking.dart uses multicast_dns for discovery and generates a game ID with uuid, joined via QR code or IP, confirmed by successful device connections.
  REQ-017 Add animations for turn passing As a player, I want visual feedback when turns change in multiplayer. The app displays a raven flight animation between devices during turn transitions, synced via WebSocket, verified by multi-device play.
  REQ-018 Add sound effects and haptic feedback As a player, I want audio and tactile feedback to enhance immersion. The app includes Viking horn sounds for wins, dice rattles for rolls, and haptic feedback on bets, confirmed by user interaction.
  REQ-019 Ensure cross-platform compatibility As a user, I want the app to work seamlessly on Android and iOS. The app builds and runs without errors on Android (API 36) and iOS (13.0+), verified by testing on SM S928U1 and iOS simulator.

- **Detail Requirements for REQ-007: Implement Liar's Dice Game with Singleplayer Mode**:
  Sub-Requirement ID Description User Story Expected Behavior/Outcome
  REQ-007-001 Design Viking-themed Liar's Dice UI As a player, I want a visually appealing interface that reflects the Viking theme. The lib/games/liars_dice/screen.dart renders a Scaffold with a Container using a DecorationImage from assets/common/longship_background.png (or a campfire-specific asset). The UI includes a dice cup (horn) with 5 rune-etched bone dice, a bid input field, and a challenge button, styled with Theme.of(context).cardColor(brown[900]) and runic text (bodyLarge), verified by launching the screen.
  REQ-007-002 Implement dice rolling logic As a player, I want to roll dice to start each turn. The lib/games/liars_dice/logic.dart includes a LiarDiceLogic class with a method to roll 5 dice (random values 1-6), storing results privately. The screen updates to show the cup with an animation (e.g., shake), confirmed by a successful roll on tap.
  REQ-007-003 Enable user bidding As a player, I want to place bids on the total number and face of dice. The logic.dart supports a bid method accepting quantity and face (e.g., "5 fours"), and screen.dart provides a text input or dropdown for bids. Users can submit a bid, updating the game state, verified by a valid bid being accepted.
  REQ-007-004 Implement AI bidding logic As a player, I want an AI opponent to bid intelligently. The LiarDiceLogic class includes an aiBid method using probability-based logic (e.g., based on hidden dice totals), making a bid after the user. The screen displays the AI's bid, confirmed by a realistic AI turn following the user's bid.
  REQ-007-005 Add challenge mechanic As a player, I want to challenge the AI's bid to test my bluffing skills. The logic.dart includes a challenge method that compares the user's and AI's dice totals. If the challenge succeeds (total matches or exceeds bid), the AI loses a die; otherwise, the user loses a die. The screen reveals all dice and updates the count, verified by a correct outcome after a challenge.
  REQ-007-006 Manage game state and win condition As a player, I want the game to track progress and end when someone wins. The LiarDiceLogic tracks dice counts (5 per player initially) and ends when one reaches 0, declaring the last player standing the winner. The screen displays the current dice count and a win message (e.g., "Victory!" with a Viking horn sound), confirmed by a complete game round.
  REQ-007-007 Integrate with existing theme As a designer, I want the Liar's Dice screen to match the app's Viking aesthetic. The screen.dart uses Theme.of(context) for colors (e.g., cardColor, textTheme.bodyLarge) and the runic font (RuneFont). The UI includes Viking motifs (e.g., horn cup, rune dice), verified by visual consistency with the opening screen.

- **Detail Requirements for REQ-008: Implement Liar's Dice Game with Multiplayer Mode**:
  Sub-Requirement ID Description User Story Expected Behavior/Outcome
  REQ-008-001 Set up multiplayer networking infrastructure for Liar's Dice As a developer, I want a robust networking setup to enable multiplayer Liar's Dice over local WiFi. The lib/common/networking.dart file initializes a WebSocket server using web_socket_channel for the host and clients. multicast_dns discovers devices, and network_info_plusprovides local IP addresses. A successful connection between at least two devices on the same WiFi is verified by a log message or UI indicator.
  REQ-008-002 Create a session ID and join mechanism As a host, I want to create a unique session and allow others to join easily. The host generates a unique session ID using uuid and broadcasts it via multicast_dns. Clients join by scanning a QR code (generated with a package like qr_flutter) or entering the IP, confirmed by a joined player list in the UI on the host device.
  REQ-008-003 Synchronize dice rolls across devices As a player, I want my dice rolls to be hidden and synced with others for fair play. Each player rolls dice privately on their device, sending the roll count (not values) via WebSocket. The lib/games/liars_dice/logic.dart aggregates total dice, verified by matching counts across devices without revealing individual rolls.
  REQ-008-004 Implement turn-based bidding system As a player, I want to take turns bidding on dice totals in a structured way. The lib/games/liars_dice/logic.dart manages turn order, passing via WebSocket when a player submits a bid (e.g., "5 fours"). The current player’s turn is highlighted with a raven animation, confirmed by sequential turn changes on multi-device play.
  REQ-008-005 Add bluff challenge mechanic As a player, I want to challenge others' bids to add strategy. Players can challenge a bid using a UI button, triggering lib/games/liars_dice/logic.dart to reveal all dice via WebSocket. The challenger wins if the bid is false; the bidder loses a die otherwise, verified by updated dice counts and a thunderclap sound effect.
  REQ-008-006 Handle game state and win condition As a player, I want the game to end when someone wins and reflect the outcome. The lib/games/liars_dice/logic.dart tracks dice loss; the last player with dice wins. The game state (dice counts, turn) syncs across devices, and a win screen with Viking horn sound is displayed, confirmed by a multiplayer game ending correctly.
  REQ-008-007 Integrate verbal bidding off-app As a player, I want to announce bids verbally for an authentic experience. The app prompts players to speak bids aloud (e.g., via a text hint), with WebSocket syncing only the challenge action. Verbal interaction is verified by successful gameplay without app-enforced speech recognition.
  REQ-008-008 Add visual feedback for turn passing As a player, I want to see when my turn changes to another device. A raven flight animation transitions between devices during turn changes, synced via WebSocket, verified by visible animation on all connected devices.
  REQ-008-009 Ensure multi-device synchronization stability As a user, I want a smooth multiplayer experience without desyncs. The lib/common/networking.dart handles WebSocket reconnection and state reconciliation. A test with three devices maintains consistent dice counts and turn order, confirmed by no desync errors over a 10-minute session.
  REQ-008-010 Test multiplayer mode on multiple devices As a tester, I want to verify multiplayer functionality across devices. The app is tested with 2–4 devices on the same WiFi, covering connection, turn passing, bidding, and challenges. All actions sync correctly, and no crashes occur, verified by a test report.

- **Detail Requirements for REQ-005: Implement Poker Game with Singleplayer Mode**:
  Sub-Requirement ID Description User Story Expected Behavior/Outcome
  REQ-005-001 Define Poker game logic structure As a developer, I want a structured logic class for Poker to manage game state and rules. The lib/games/poker/logic.dart file contains a PokerLogic class with VikingSuit (axes, shields, ravens, ships) and Rank (two through ace) enums, a Card class, and a deck list initialized with 52 cards. The deck is shuffled on instantiation, verified by logging the deck size (52) and random order.
  REQ-005-002 Implement basic card dealing for single-player As a player, I want to be dealt cards to start a Poker game against an AI. The PokerLogic class includes a dealCards() method that distributes 2 hole cards to the player and AI, returning a map (e.g., {player: [Card], ai: [Card]}). The lib/games/poker/screen.dart displays these cards on a Viking-themed table, confirmed by seeing 2 cards each on screen after a deal button press.
  REQ-005-003 Add community card dealing As a player, I want community cards to be dealt during the game for hand evaluation. The PokerLogic class includes a dealCommunityCards() method that deals 3 flop cards, 1 turn card, and 1 river card in sequence, updating the game state. The screen.dart updates the UI to show 5 community cards after simulated betting rounds, verified by visual progression.
  REQ-005-004 Implement AI opponent logic As a player, I want an AI opponent to make reasonable betting decisions. The PokerLogic class includes an aiDecision() method using rule-based logic (e.g., fold on weak hands < 10% win probability, call/bet on strong hands > 50%), updated per round. The AI’s actions (fold, call, raise) are displayed in screen.dart, confirmed by consistent AI behavior over multiple games.
  REQ-005-005 Create basic UI for Poker gameplay As a player, I want a user interface to interact with the Poker game. The lib/games/poker/screen.dart implements a Scaffold with a Viking plank-wood table background (assets/common/longship_background.png), displaying player/AI cards, community cards, and buttons for deal, bet, call, fold. The UI is responsive, verified by launching on SM S928U1.
  REQ-005-006 Add betting and folding mechanics As a player, I want to bet, call, or fold during the game. The PokerLogic class tracks a pot and player/AI chips, with methods for bet(amount), call(), and fold(). The screen.dart includes buttons triggering these actions, updating the UI with chip counts and pot value, confirmed by successful bet/fold cycles.
  REQ-005-007 Determine and display game outcome As a player, I want to know the winner after each round. The PokerLogic class includes a evaluateHand() method to compare player and AI hands (e.g., high card, pair, flush) using a ranking system. The screen.dart displays the winner (player or AI) with a northern lights animation, verified by correct outcomes after betting.
  REQ-005-008 Integrate Viking-themed assets and effects As a player, I want a Viking aesthetic to enhance the Poker experience. The screen.dart uses rune-suited cards (VikingSuit), a longship table, and gold coin animations for bets. Sound effects (e.g., coin clink) and haptic feedback on bets are included, confirmed by visual/audio/tactile feedback during play.
  REQ-005-009 Ensure single-player mode stability As a developer, I want the single-player mode to be bug-free and performant. The PokerLogic and screen.dart are tested with unit tests (test/games/poker/poker_logic_test.dart) and integration tests, achieving 100% coverage for deal, bet, and outcome logic. Performance targets 60 FPS, verified by profiling on SM S928U1.

- **Detail Requirements for REQ-006: Implement Poker Game with Multiplayer Mode**:
  Sub-Requirement ID,Description,User Story,Expected Behavior/Outcome
  REQ-006-001,Set up multiplayer network infrastructure,"As a developer, I want a robust network setup to enable Poker multiplayer over local WiFi.","The lib/common/networking.dart implements multicast_dns for device discovery and web_socket_channel for real-time communication. A host device broadcasts availability, and clients join via a unique session ID generated with uuid, verified by successful connection logs on two devices."
  REQ-006-002,Implement host card dealing mechanism,"As a host, I want to deal cards to all players to start a Poker game.","The lib/games/poker/logic.dart extends PokerLogic to distribute 2 hole cards per player and 5 community cards via WebSocket. The host shuffles the deck and sends card data (e.g., JSON with suit/rank) to connected devices, confirmed by all players receiving identical card sets."
  REQ-006-003,Enable player betting and action synchronization,"As a player, I want to place bets and take actions (fold, call, raise) that are reflected across all devices.","The lib/games/poker/screen.dart includes buttons for betting actions, sending updates via WebSocket to lib/common/networking.dart. All devices display the current bet pool and player actions in real-time, verified by synchronized UI updates during a multi-device game."
  REQ-006-004,Manage turn passing with animation,"As a player, I want to see whose turn it is with a visual cue to enhance the multiplayer experience.","The lib/games/poker/screen.dart triggers a raven flight animation (using a custom AnimationController) when a turn passes, synced via WebSocket. The animation moves between player avatars (Viking helmets), confirmed by smooth transitions on all devices."
  REQ-006-005,Support verbal bluffing off-app,"As a player, I want to use verbal communication for bluffing to add a social element without app modification.","The app design allows players to announce bluffs verbally during their turn, with no in-app text input required. Multiplayer sessions rely on off-app communication, verified by successful gameplay where bluffing impacts strategy without technical intervention."
  REQ-006-006,Handle multi-device state consistency,"As a player, I want the game state to remain consistent across all devices to ensure fair play.","The lib/common/networking.dart syncs game state (e.g., current player, pot, cards) using JSON serialization with json_annotation. State updates are broadcast on each action, confirmed by identical displays on all devices after a full round."
  REQ-006-007,Provide session creation and joining,"As a host or client, I want an easy way to create or join a Poker game session.","The lib/common/networking.dart generates a session ID (QR code or IP display) on the host device. Clients scan the QR or enter the IP using network_info_plus, verified by a successful join message and game start on both devices."
  REQ-006-008,Ensure turn-based gameplay flow,"As a player, I want turns to progress smoothly to maintain game pace in multiplayer.","The lib/games/poker/logic.dart manages turn order (e.g., clockwise after the dealer), synced via WebSocket. Each player’s turn is highlighted with a Viking shield icon, confirmed by orderly turn progression across devices."
  REQ-006-009,Handle disconnection and reconnection,"As a player, I want the game to handle temporary disconnections gracefully.","The lib/common/networking.dart implements a reconnection mechanism with WebSocket, resyncing the last known state. Disconnected players can rejoin with the session ID, verified by resuming play without data loss after a simulated disconnect."
  REQ-006-010,Validate multiplayer game end conditions,"As a player, I want the game to end properly when a winner is determined.","The lib/games/poker/logic.dart detects win conditions (e.g., all-in, fold-out) and broadcasts the result via WebSocket. The lib/games/poker/screen.dart displays a win animation (northern lights), confirmed by a consistent end state on all devices."
