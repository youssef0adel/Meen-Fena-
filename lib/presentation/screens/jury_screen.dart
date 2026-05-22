import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';

class JuryScreen extends StatefulWidget {
  const JuryScreen({super.key});
  @override
  State<JuryScreen> createState() => _JuryScreenState();
}

class _JuryScreenState extends State<JuryScreen> {
  int _currentJurorIndex = 0;
  bool _processed = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    
    // ✅ لو وصلنا للشاشة دي وفيها مشكلة - نروح للنهاية مباشرة
    if (gameProvider.currentPhase == GamePhase.endgame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/endgame');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final jurySystem = gameProvider.jurySystem;

    // ✅ لو مفيش محلفين، نروح للنهاية مباشرة
    if (jurySystem == null || jurySystem.eliminatedPlayers.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameProvider.processJuryVotes();
        Navigator.pushReplacementNamed(context, '/endgame');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final jurors = jurySystem.eliminatedPlayers;
    final suspects = jurySystem.finalSuspects;

    // ✅ لو خلصنا كل المحلفين
    if (_currentJurorIndex >= jurors.length && !_processed) {
      _processed = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameProvider.processJuryVotes();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/endgame');
          }
        });
      });

      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.bloodRed),
              SizedBox(height: 16),
              Text('المحلفون يصوتون...', style: TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        ),
      );
    }

    if (_currentJurorIndex >= jurors.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentJuror = jurors[_currentJurorIndex];

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text('هيئة المحلفين - ${_currentJurorIndex + 1} من ${jurors.length}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // رسالة المحلف
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.goldAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.gavel, color: AppTheme.goldAccent, size: 35),
                const SizedBox(height: 12),
                const Text('⚖️ هيئة المحلفين', style: TextStyle(color: AppTheme.goldAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.bloodRed.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text('تم إقصاؤك سابقاً', style: TextStyle(color: AppTheme.bloodRedLight, fontSize: 12)),
                ),
                const SizedBox(height: 8),
                Text('المحلف: ${currentJuror.name}', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('صوّت على من تعتقد أنه المافيا', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('المشتبه بهم النهائيون:', style: TextStyle(color: AppTheme.goldAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: suspects.length,
              itemBuilder: (context, index) {
                final suspect = suspects[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      gameProvider.castJuryVote(currentJuror.id, suspect.id);
                      setState(() => _currentJurorIndex++);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.cardDark,
                      foregroundColor: AppTheme.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 45, height: 45,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.bloodRed.withOpacity(0.3), border: Border.all(color: AppTheme.goldAccent, width: 1.5)),
                          child: const Icon(Icons.person, color: AppTheme.goldAccent),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Text(suspect.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.goldAccent)), child: const Icon(Icons.how_to_vote, color: AppTheme.goldAccent, size: 22)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}