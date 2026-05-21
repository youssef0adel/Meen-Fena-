import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';

class EndgameScreen extends StatelessWidget {
  const EndgameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final mafiaAlive = gameProvider.players.where((p) => p.isMafia && p.isAlive).length;
    final innocentsWin = mafiaAlive == 0;

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              innocentsWin ? AppTheme.innocentBlue.withOpacity(0.3) : AppTheme.bloodRed.withOpacity(0.3),
              AppTheme.primaryDark,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  innocentsWin ? Icons.celebration : Icons.dangerous,
                  size: 80,
                  color: innocentsWin ? AppTheme.goldAccent : AppTheme.mafiaRed,
                ),
                const SizedBox(height: 24),
                Text(
                  innocentsWin ? '🎉 الأبرياء انتصروا!' : '💀 المافيا انتصرت!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: innocentsWin ? AppTheme.goldAccent : AppTheme.mafiaRed,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  innocentsWin 
                    ? 'تم القبض على جميع أفراد المافيا'
                    : 'سيطرت المافيا على اللعبة',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    gameProvider.resetGame();
                    Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('لعبة جديدة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bloodRed,
                    foregroundColor: AppTheme.goldAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}