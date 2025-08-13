import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemChrome
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/opening_screen.dart';
import 'common/theme.dart';
import 'backgammon/screen.dart';
import 'checkers/screen.dart';
import 'cribbage/screen.dart';
import 'knucklebones/screen.dart';
import 'liars_dice/screen.dart';
import 'poker/screen.dart';
import 'solitaire/screen.dart';
import 'uno/screen.dart';
import 'yatzy/screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sisu Games',
      theme: VikingTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const OpeningScreen(),
        '/backgammon': (context) => const BackgammonScreen(),
        '/checkers': (context) => const CheckersScreen(),
        '/cribbage': (context) => const CribbageScreen(),
        '/knucklebones': (context) => const KnucklebonesScreen(),
        '/liars_dice': (context) => const LiarsDiceScreen(),
        '/poker': (context) => const PokerScreen(),
        '/solitaire': (context) => const SolitaireScreen(),
        '/uno': (context) => const UnoScreen(),
        '/yatzy': (context) => const YatzyScreen(),
      },
    );
  }
}
