import 'package:flutter/material.dart';
import '../../common/ui_helpers.dart';

class LiarsDiceHelpers {
  static String cardFaceAssetForDie(int die) {
    switch (die) {
      case 1:
        return 'assets/common/kc.jpg';
      case 2:
        return 'assets/common/qc.jpg';
      case 3:
        return 'assets/common/jc.jpg';
      case 4:
        return 'assets/common/ac.jpg';
      case 5:
        return 'assets/common/10c.jpg';
      case 6:
        return 'assets/common/ks.jpg';
      default:
        return 'assets/common/kc.jpg';
    }
  }

  static String faceToString(int faceValue) {
    switch (faceValue) {
      case 1:
        return 'Ace';
      case 2:
        return 'Queen';
      case 3:
        return 'Jack';
      case 4:
        return 'King';
      case 5:
        return 'Ten';
      case 6:
        return 'King of Spades';
      default:
        return 'Unknown';
    }
  }
}
