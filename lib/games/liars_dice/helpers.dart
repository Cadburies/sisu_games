// lib/games/liars_dice/helpers.dart
import 'package:flutter/material.dart';

import '../../common/ui_helpers.dart';

class LiarsDiceHelpers {
  static String cardFaceAssetForDie(int die) {
    switch (die) {
      case 6:
        return 'assets/common/as.jpg'; // Ace (highest)
      case 5:
        return 'assets/common/ks.jpg'; // King
      case 4:
        return 'assets/common/qs.jpg'; // Queen
      case 3:
        return 'assets/common/js.jpg'; // Jack
      case 2:
        return 'assets/common/10s.jpg'; // Ten
      case 1:
        return 'assets/common/9s.jpg'; // Nine (lowest)
      default:
        return 'assets/common/ah.jpg';
    }
  }

  static String faceToString(int faceValue) {
    switch (faceValue) {
      case 6:
        return 'Ace';
      case 5:
        return 'King';
      case 4:
        return 'Queen';
      case 3:
        return 'Jack';
      case 2:
        return 'Ten';
      case 1:
        return 'Nine';
      default:
        return 'Unknown';
    }
  }

  /// Sample dice display for poker hand ranks (game-specific)
  static Widget sampleDiceForRank(
    BuildContext context,
    String rankName, {
    double size = 30,
  }) {
    List<int> sampleDice;
    switch (rankName.toLowerCase()) {
      case 'five of a kind':
        sampleDice = [6, 6, 6, 6, 6]; // Ace
        break;
      case 'four of a kind':
        sampleDice = [6, 6, 6, 6, 1]; // Aces with Nine
        break;
      case 'full house':
        sampleDice = [6, 6, 6, 5, 5]; // Aces over Kings
        break;
      case 'high straight':
        sampleDice = [2, 3, 4, 5, 6]; // Ten to Ace
        break;
      case 'low straight':
        sampleDice = [1, 2, 3, 4, 5]; // Nine to King
        break;
      case 'three of a kind':
        sampleDice = [6, 6, 6, 1, 2]; // Aces with high kickers
        break;
      case 'two pair':
        sampleDice = [6, 6, 5, 5, 1]; // Aces and Kings
        break;
      case 'one pair':
        sampleDice = [6, 6, 1, 2, 3]; // Aces with high kickers
        break;
      case 'high die':
        sampleDice = [6]; // Ace
        break;
      default:
        sampleDice = [1, 2, 3, 4, 5];
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: sampleDice
          .map(
            (value) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: UIHelpers.vikingDiceFace(context, value, size: size),
            ),
          )
          .toList(),
    );
  }
}
