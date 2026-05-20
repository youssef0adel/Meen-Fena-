import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/main_menu_screen.dart';
import 'presentation/screens/player_setup_screen.dart';
import 'presentation/screens/role_reveal_screen.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/screens/voting_screen.dart';
import 'presentation/screens/endgame_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/lan_game_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext ctx) { // ✅ غيرت الاسم لتجنب التعارض
    return MaterialApp(
      title: 'مين فينا؟',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkNoirTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/menu': (_) => const MainMenuScreen(),
        '/player-setup': (_) => const PlayerSetupScreen(),
        '/role-reveal': (_) => const RoleRevealScreen(),
        '/game': (_) => const GameScreen(),
        '/voting': (_) => const VotingScreen(),
        '/endgame': (_) => const EndgameScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/lan-game': (_) => const LANGameScreen(),
      },
    );
  }
}