import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/main_menu_screen.dart';
import 'presentation/screens/player_setup_screen.dart';
import 'presentation/screens/role_reveal_screen.dart';
import 'presentation/screens/case_intro_screen.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/screens/voting_screen.dart';
import 'presentation/screens/jury_screen.dart';
import 'presentation/screens/endgame_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/lan_game_screen.dart';
import 'presentation/screens/lan_lobby_screen.dart';
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'مين فينا؟',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkNoirTheme,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG'), Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            switch (settings.name) {
              case '/splash': return const SplashScreen();
              case '/menu': return const MainMenuScreen();
              case '/player-setup': return const PlayerSetupScreen();
              case '/role-reveal': return const RoleRevealScreen();
              case '/case-intro': return const CaseIntroScreen();
              case '/game': return const GameScreen();
              case '/voting': return const VotingScreen();
              case '/jury': return const JuryScreen();
              case '/endgame': return const EndgameScreen();
              case '/settings': return const SettingsScreen();
              case '/lan-game': return const LANGameScreen();
              case '/lan-host':return const LANLobbyScreen(isHost: true);
              case '/lan-join':return LANLobbyScreen(isHost: false, hostIp: settings.arguments as String?);
              default: return const MainMenuScreen();
            }
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      },
    );
  }
}