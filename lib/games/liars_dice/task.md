# Sisu Games - Development Tasks

Always read at the start of a chat, the pr.md file to understand the project's environment. Also, read any file or structure you require to understand or verify tasks or issues.

### Step-by-Step Instructions for Implementing Liar's Dice in Sisu Games

A junior programmer tried to follow the logical steps for implementing Liar's Dice (Common Hand variant) for the Sisu Games app. Your job as Advanced Senior Programmer, is to follow these steps sequentially and verify that the junior programmer did their job correctly. Ensure all UI elements incorporate the Viking theme—use weathered wood backgrounds, rune-etched dice icons (e.g., bone-carved with Norse runes for numbers 1-6), shield-shaped counters, and nautical motifs like fjord waves or longship sails for buttons and transitions. Structure your work in `lib/games/liars_dice/` for game-specific files (e.g., `logic.dart` for game logic, `screen.dart` for UI, `helpers.dart` for utilities) and `assets/games/liars_dice/` for themed assets. Use shared code from `lib/common/` for networking, UI helpers, and logic. Add files or functions as you see fit. Also check that the junior programmer did not leave any stale code so, even remove files or functions that is not used. Implement single-player with AI first, then add local WiFi multiplayer using peer-to-peer sync via WebSockets. Test incrementally with unit tests for logic and integration tests for multiplayer.

Focus on modern Flutter/Dart practices: Use Riverpod for state management, custom viking ThemeData from `lib/common/theme.dart` for consistent styling (e.g., deep blues for seas, earthy browns for wood, runic fonts like NotoSansRunic-Regular.ttf for text), and responsive layouts with MediaQuery for various screen sizes. Animate turns with a raven flying across the screen for passing control.

#### Step 1: Initialize Game State

- Create a game state class to hold variables like player counters, current turn, dice values, and bid history.
- On game launch (from the opening screen's themed icon tap), assign 10 counters to each player (including AI in single-player or connected devices in multiplayer).
- Roll initial dice for all players to determine the first player: Compare poker-style hands (e.g., Five of a Kind highest, down to Highest Single Number).
- Update UI to display counters as shield icons, current player's turn with a glowing rune highlight, and show opponents' dice for transparency.

#### Step 2: Implement Dice Roll and Hold

- For the current player's turn, display their 5 dice as interactive, rune-etched icons.
- Allow tapping a die to toggle hold state: Change color (golden glow border with a lock icon for hold) and prevent rolling held dice.
- Show only roll dice button. No declare button or rank and face dropdowns are visible.
- On roll button press (styled as a Viking horn), generate new random values (1-6) only for non-held dice.
- In multiplayer, sync only the roll action (not dice values) to others.

#### Step 3: Handle Rank and Face Value Declaration

- After rolling, disable roll button and show dropdowns or rune-styled selectors for rank (1-9, where 1=High Card, 9=Five of a Kind) and face value (1-6), no card faces such as Jacks or Queens.
- Validate declaration: Must be higher than previous bid (compare rank first, then face if ranks equal).
- After player selected both drop downs, then show declare button.
- On declare (button styled as a sail flag), add to bid history and pass turn to next player with raven animation.
- Update bid history display as a scrollable list of rune-carved plaques.
- The next player (or AI) will then get the chance to accept or challenge.
- In multiplayer, sync dice state only to next player's devices.

#### Step 4: Manage AI Turn and Player Response

- In single-player, after player declares, delay 2 seconds with "AI is thinking"
- AI logic is to roll odd dice for example, when there is a pair, then hold the pair and roll the three odd dice. Another example is when there is four of a kind, the hold the four of a kind cards and roll the odd dice.
- Declared hand must be higher than previous player's turn.
- Show AI's declaration in UI, then prompt player with dialog (accept or challenge, styled as Viking shield buttons).
- If accept, pass the turn to next player for next hand; if challenge, proceed to challenge resolution in next session.
- In multiplayer, handle turns via synced WebSocket messages instead of AI.

#### Step 5: Process Challenges

- On challenge, reveal all players' dice (animate reveal with wave effect).
- Evaluate actual combined hand rank and face from all dice.
- Compare to declared bid: If actual >= declared, challenger loses a counter (decrement their counter); else, declarer loses a counter.
- Display result message (e.g., rune-etched toast: "Challenge failed! Lose a shield."), update counters.
- Show "New Round" button. If button is clicked, then hide it again.
- Reset round: Re-roll all dice, clear bid history, pass turn to winner of challenge.

#### Step 6: Handle Game End Conditions

- After each challenge or counter loss, check if any player has 0 counters.
- If a player reaches 0, end game: Announce winner (last with counters) with victory animation (e.g., longship sailing into fjord).
- Show "Play Again" button (styled as axe) to reset state or return to opening screen.
- In multiplayer, sync end state to all devices.

#### Step 7: Synchronize Multiplayer State

- Use WebSocket from `lib/common/networking.dart` to broadcast state changes (counters, bid history, turn, dice rolls/actions, winner).
- On connection (via multicast_dns discovery), sync initial state.
- Listen for incoming messages to update local state and UI in real-time.
- Handle disconnections gracefully with reconnect prompts.
- Test with multiple emulators to verify identical states across devices.
