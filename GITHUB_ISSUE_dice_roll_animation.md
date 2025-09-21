# GitHub Issue: Add animated dice roll simulation for determining first player in single-player mode

## Title
Add animated dice roll simulation for determining first player in single-player mode

## Labels
enhancement, ui/ux, liars-dice, animation

## Issue Body

### Problem Description

In single-player mode against AI, the initial dice roll to determine who starts first happens too quickly and feels abrupt. Players cannot visually confirm the fairness of the roll, making the app appear less trustworthy.

### Proposed Solution

- Add a rolling dice animation before showing the final roll results
- Display both player's and AI's dice sets simultaneously after the animation
- Include a brief delay to allow visual confirmation that the app is not cheating
- Make this animation only apply to single-player mode (multiplayer can remain fast)

### Technical Implementation

Modify the `determineFirstPlayer()` method in `common_hand_logic.dart` to:
1. Add a visual dice-rolling animation sequence
2. Show both dice sets in the UI with animation
3. Add appropriate delays for user experience
4. Ensure single-player mode has this enhanced UX while multiplayer remains efficient

### Priority
High - Trust and fairness perception is crucial for bluffing games like Liars Dice.

### Code Location
- File: `lib/games/liars_dice/logic/common_hand_logic.dart`
- Method: `determineFirstPlayer()`
- UI File: `lib/games/liars_dice/screen.dart`

### Related Files
- `lib/games/liars_dice/state/game_state.dart`
- `lib/games/liars_dice/state/game_state_notifier.dart`
- `lib/common/dice_widget.dart`
