import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/main_menu_screen.dart';
import 'presentation/screens/player_setup_screen.dart';
import 'presentation/screens/role_reveal_screen.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/screens/voting_screen.dart';
import 'presentation/screens/endgame_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مين فينا؟',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkNoirTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/menu': (context) => const MainMenuScreen(),
        '/player-setup': (context) => const PlayerSetupScreen(),
        '/role-reveal': (context) => const RoleRevealScreen(),
        '/game': (context) => const GameScreen(),
        '/voting': (context) => const VotingScreen(),
        '/endgame': (context) => const EndgameScreen(),
      },
    );
  }
}