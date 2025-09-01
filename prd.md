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
