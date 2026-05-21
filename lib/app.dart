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

// تأكد من وجود كل المسارات:


class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'مين فينا؟',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkNoirTheme,
      initialRoute: '/splash',
      // ✅ إضافة أنيميشن للانتقال بين الصفحات
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            switch (settings.name) {
              case '/splash':
                return const SplashScreen();
              case '/menu':
                return const MainMenuScreen();
              case '/player-setup':
                return const PlayerSetupScreen();
              case '/role-reveal':
                return const RoleRevealScreen();
              case '/game':
                return const GameScreen();
              case '/voting':
                return const VotingScreen();
              case '/endgame':
                return const EndgameScreen();
              case '/settings':
                return const SettingsScreen();
              case '/lan-game':
                return const LANGameScreen();
              default:
                return const MainMenuScreen();
            }
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}