import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'presentation/providers/game_provider.dart';
import 'presentation/providers/audio_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const MeenFenaApp());
}

class MeenFenaApp extends StatelessWidget {
  const MeenFenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const AppRoot(),
    );
  }
}

// Add to app.dart routes:
'/settings': (context) => const SettingsScreen(),
'/lan-game': (context) => const LANGameScreen(),

// Add settings button to main menu
MenuButton(
  icon: Icons.settings,
  label: 'Settings',
  description: 'Game options & rules',
  onTap: () {
    Navigator.pushNamed(context, '/settings');
  },
),