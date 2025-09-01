# Changelog

All notable changes to the Sisu Games project will be documented in this file.

## [Unreleased] date: 1 September 2025

## Issues Fixed:

### 1. **AI Dice Visibility** ✅

- AI dice now only show during challenge or game over phases
- Added proper conditional rendering with `SizedBox.shrink()` when not needed
- AI dice display actual values from the game logic
- Removed interactive behavior from AI dice (no tap handlers)

### 2. **Dropdown Theming** ✅

- Dropdowns are already properly themed with Viking colors
- Using `VikingTheme.cardBackground` for dropdown background
- Using `VikingTheme.accentYellow` for text and borders
- Proper contrast and readability maintained

### 3. **Game Flow After First Turn Determination** ✅

- Fixed the initialization sequence in `GameStateNotifier`
- After determining first player, the game now properly allows the first player to roll their dice
- Added `_initializeGame()` method that sets up the correct flow
- Added `_aiRollDice()` method for AI turns
- Status messages now clearly indicate whose turn it is

### 4. **Added Missing UI Controls** ✅

- **Roll Dice Button**: Appears when it's player's turn and rolling is enabled
- **Declare Button**: Appears after rolling, enabled when rank and face are selected
- **Challenge Button**: Always available after rolling
- All buttons use proper Viking theming
- Selections are reset after declaration

## Game Flow Now Works Correctly:

1. **Initial Setup**: Roll dice to determine first player
2. **First Player Turn**: "You go first! Roll your dice for your turn"
3. **Dice Rolling**: Player can hold dice and roll
4. **Declaration Phase**: Select rank and face value, then Declare or Challenge
5. **AI Turn**: AI rolls and makes its declaration
6. **Challenge Resolution**: Show dice and resolve challenges properly

### Marked as Completed:

- **Theme and Common Components**: All items including theme.dart, ui_helpers.dart, logic_helpers.dart, networking.dart
- **Liar's Dice Implementation**: Core logic, UI components, and most features
- **Multiplayer Support**: Full WiFi multiplayer implementation
- **Opening Screen**: Complete with game grid and toggle
- **State Management**: Riverpod implementation with full game logic

### Added Missing Items:

- **dice_widget.dart**: Separate file for dice component with animations
- **opening_screen.dart**: Main app screen implementation
- **card_logic_helpers.dart**: Card game utilities
- **State management files**: game_state.dart, game_state_notifier.dart, multiplayer_state.dart
- **Model files**: poker_hand_rank.dart
- **Multiplayer Implementation section**: Complete with WebSocket support

### Updated Milestones:

- **First Milestone (Single Player Liar's Dice)**: Marked as completed
- **Added Second Milestone (Multiplayer Liar's Dice)**: Also completed
- **Other Games**: Noted as basic screen structures only

### Remaining Work:

- Unit and integration tests
- Documentation (README, code docs)
- Sound effects and tutorial mode
- Completion of other games beyond basic screens

The task.md now provides an accurate representation of the project's advanced state, showing that Liar's Dice is fully implemented with multiplayer support, while other games need completion.

## [Unreleased] date: 30 August 2025

### Added

- Initial project structure setup
- Common helpers setup

  - Created lib/common/theme.dart with Viking theme
  - Created lib/common/ui_helpers.dart with DiceWidget
  - Created lib/common/logic_helpers.dart
  - Created lib/common/networking.dart

- Liar's Dice Game Implementation
  - Basic game structure in lib/games/liars_dice/
  - Game state management using Riverpod
  - DiceWidget with Viking theme styling
  - Player and AI dice display
  - Roll animation implementation
  - Hand rank calculation logic
  - Turn management system
  - Rank and face value selection UI

### Changed

- Refactored theme implementation for better consistency
- Updated DiceWidget to use single background image
- Improved readability of game text for accessibility
- Reorganized game logic into separate files
- Moved common functions to appropriate helper files

### Fixed

- Theme deprecation warnings
  - Replaced dialogBackgroundColor with DialogTheme
  - Updated color opacity handling
  - Fixed MaterialStateProperty deprecations
- Game state management issues
  - Consolidated duplicate starter determination functions
  - Fixed state updates for turn transitions
- UI Layout issues
  - Fixed right overflow in rank/face selection
  - Improved dropdown styling
  - Fixed dice display layout

### Known Issues

- Multiplayer implementation pending
- Missing some Viking-themed assets
- Need to implement proper error handling
- AI strategy needs improvement
- Missing unit tests
- Missing integration tests

## [Next Steps]

- Complete single-player game flow
- Add proper victory/defeat conditions
- Implement multiplayer networking
- Add unit tests for game logic
- Add integration tests for UI flow
- Generate remaining Viking-themed assets
