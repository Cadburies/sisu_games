# GitHub Issue: Enhance dice visualization for poker hand ranks
**Status:** Ready to create on GitHub
**URL:** TBD

## Title
Enhance dice visualization in rank dropdown for better poker hand understanding

## Labels
enhancement, ux, frontend, liars-dice, visual-design

## Assignee
cline

## Issue Body

### Problem Description

While the rank dropdown will show user-friendly names like "Three of a Kind", users still need clear visual examples of what each poker hand represents with actual dice. Currently, the dice examples may not clearly demonstrate the ranking hierarchy or hand structure.

### Current Behavior
- Existing sample dice (e.g., [6,6,5,3,2]) don't clearly represent the specific hand pattern
- Users can't easily visualize how the dice create the ranked hand
- Less experienced players may not understand the ranking system

### Proposed Solution

Update `LiarsDiceHelpers.sampleDiceForRank()` to show representative examples that clearly demonstrate each hand type:

**fiveOfAKind** → [6,6,6,6,6] - All same, highest rank
**fourOfAKind** → [6,6,6,6,5] - Four same (6s), one different (5)
**fullHouse** → [6,6,6,5,5] - Three of one (6s), two of another (5s)
**highStraight** → [2,3,4,5,6] - Sequential ascending 2-6
**lowStraight** → [1,2,3,4,5] - Sequential ascending 1-5
**threeOfAKind** → [6,6,6,5,4] - Three same (6s highest), 5 and 4 different
**twoPair** → [6,6,5,5,4] - Two pairs (6s and 5s), one different (4)
**onePair** → [6,6,5,4,3] - One pair (6s), three different (5,4,3)
**highCard** → [6,5,4,3,2] - All different, 6 highest

### Key Visual Improvements

For **Three of a Kind** specifically:
- Show three dice with identical highest rank (6,6,6)
- Show remaining two dice with next highest ranks (5,4)
- Clearly demonstrates the hand hierarchy and structure
- Users can instantly understand this represents "three of a kind"

### Technical Implementation

Update `lib/games/liars_dice/helpers.dart`:

```dart
static Widget sampleDiceForRank(
  BuildContext context,
  String rankName, {
  double size = 26,
}) {
  List<int> sampleDice = getRepresentativeDice(rankName);
  // Render dice widgets...
}
```

Where `getRepresentativeDice` returns specific patterns that clearly show the hand structure.

### Expected Visual Impact
- **Immediate recognition**: Users can instantly see what makes each hand type
- **Educational**: Learn poker rankings through visual examples
- **Consistent**: All dice follow the same high-to-low ranking principles
- **Theme-consistent**: Uses existing Viking dice rendering

### Priority
High - Directly improves user understanding of core mechanics

### Testing Requirements
- Verify all 9 hands show distinctive, recognizable patterns
- Test with various screen sizes (dice scale properly)
- Ensure visual dice match the dropdown selection

### Dependencies
Depends on #2 (rank dropdown friendly text), as the visual enhancements build on the text changes.
