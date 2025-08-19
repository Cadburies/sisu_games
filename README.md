# MIT License

Copyright (c) 2025 Frik Olivier

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

# Sisu Games

Sisu Games is a Viking-themed multiplayer game app built with Flutter, evoking the spirit of ancient Norse seafarers. Players gather around virtual campfires on longships, playing classic sailor games with a Norse twist—weathered wood textures, rune carvings, stormy fjords, shields, axes, and nautical motifs permeate the UI. The app supports single-player and local WiFi multiplayer (no internet required), with games like Poker, Liar's Dice, and Solitaire. It's designed for Android and iOS, using modern Flutter best practices like Riverpod for state management and edge-to-edge full-screen layouts.

## Features

- **Viking Theme**: Immersive Norse aesthetics with deep blues, earthy browns, and runic fonts. Backgrounds depict stormy seas and longship decks; icons are rune-etched (e.g., poker cards as shield designs).
- **Games**:
  - Poker: Texas Hold'em with Viking-suited cards (axes, shields, ravens, ships).
  - Liar's Dice: Bluffing with rune-etched bone dice in horn cups.
  - Solitaire: Klondike variant on a plank-wood table.
  - More to come: Backgammon (Hnefatafl), Checkers (Viking Chess), Yatzy, Uno, and Cribbage.
- **Multiplayer**: Local WiFi host-client or peer-to-peer sync using WebSockets (`web_socket_channel`) and device discovery (`multicast_dns`, `network_info_plus`). Turns pass with animated raven flights; verbal elements (e.g., bluffing) handled off-app.
- **Single-Player**: AI opponents with rule-based decisions.
- **Cross-Platform**: Responsive for Android and iOS; full-screen mode with system bar overlays.
- **Modular Structure**: Games in `lib/games/[game_name]/` with separate logic and UI; shared Viking theme and networking in `lib/common/`.

## Installation

1. **Prerequisites**:

   - Flutter SDK (3.32.8 or later).
   - Dart SDK (3.8.1 or later).
   - Android Studio or Xcode for platform setup.
   - Git for cloning the repo.

2. **Clone the Repository**:

   ```
   git clone https://github.com/your-username/sisu-games.git
   cd sisu-games
   ```

3. **Install Dependencies**:

   ```
   flutter pub get
   ```

4. **Run the App**:
   - For Android:
     ```
     flutter run -d <android-device>
     ```
   - For iOS:
     ```
     flutter run -d <ios-simulator-or-device>
     ```

## Usage

- Launch the app to see the opening screen (longship deck dashboard).
- Select a game icon to start (e.g., Poker).
- Toggle multiplayer mode to join/host a local WiFi session.
- In multiplayer, one device hosts; others join via discovery. Turns pass automatically with animations.

## Contributing

Contributions are welcome! Fork the repo, create a branch for your feature, and submit a pull request. Follow Flutter best practices:

- Use Riverpod for state.
- Maintain Viking theme in UI.
- Add tests in `test/` for logic.

## License

This project is licensed under the MIT License—see the [LICENSE](LICENSE) file for details.
