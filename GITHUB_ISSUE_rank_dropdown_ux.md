# GitHub Issue: Improve rank dropdown user-friendliness in Liars Dice
**Status:** Live on GitHub
**URL:** https://github.com/Cadburies/sisu_games/issues/2

## Title
Improve rank dropdown user-friendliness for Liars Dice - replace enum names with readable text

## Labels
enhancement

## Assignee
cline (requested, but not available - only Cadburies assignable)

## Issue Body

### Problem Description

The rank dropdown in the Liars Dice game declaration UI currently displays raw enum values (e.g., "threeOfAKind", "fourOfAKind"), which are not user-friendly and break the game's immersive Viking theme. Users expect readable, natural language options that are consistent with the game's aesthetic.

### Current Behavior
- Dropdown shows: `threeOfAKind`, `fourOfAKind`, `fullHouse`, etc.
- Technical naming feels out of place in a themed gaming experience
- Poor UX for casual players

### Proposed Solution

Replace enum-based display names with user-friendly, readable alternatives:

| Current Enum | Proposed Display Text |
|--------------|----------------------|
| `fiveOfAKind` | "Five of a Kind" |
| `fourOfAKind` | "Four of a Kind" |
| `fullHouse` | "Full House" |
| `highStraight` | "High Straight" |
| `lowStraight` | "Low Straight" |
| `threeOfAKind` | "Three of a Kind" |
| `twoPair` | "Two Pair" |
| `onePair` | "One Pair" |
| `highCard` | "High Card" |

### Technical Implementation

- Modify the dropdown item builders in `lib/games/liars_dice/screen.dart`
- Add a helper method to convert `PokerHandRank` enum to display strings
- Consider adding this to `lib/games/liars_dice/helpers.dart` for reusability
- Ensure consistent formatting (Title Case with spaces)
- Maintain the underlying enum values for game logic

### Files to Modify
- `lib/games/liars_dice/screen.dart` (dropdown UI)
- `lib/games/liars_dice/helpers.dart` (add display formatting method)
- `lib/games/liars_dice/models/poker_hand_rank.dart` (consider adding extension method)

### Priority
Medium - Improves user experience but doesn't affect core gameplay functionality.

### Related Components
- Game declaration flow
- Bid history display (if it also shows raw enum names)
- Poker hand ranking system (logic should remain unchanged)

### Testing Notes
- Verify all 9 hand ranks display correctly
- Ensure dropdown selection still works with game logic
- Test on both single-player and multiplayer modes
- Validate bid history maintains correct information
