import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});
  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int _currentVoterIndex = 0;
  bool _processed = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final alivePlayers = gameProvider.alivePlayers;

    // ✅ كل الكود جوه build method
    if (_currentVoterIndex >= alivePlayers.length && !_processed) {
      _processed = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameProvider.processElimination();

        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;

          if (gameProvider.currentPhase == GamePhase.juryDeliberation) {
            Navigator.pushReplacementNamed(context, '/jury');
          } else if (gameProvider.currentPhase == GamePhase.endgame) {
            Navigator.pushReplacementNamed(context, '/endgame');
          } else {
            Navigator.pushReplacementNamed(context, '/game');
          }
        });
      });

      return Scaffold(
        backgroundColor: AppTheme.primaryDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: AppTheme.bloodRed),
              SizedBox(height: 16),
              Text('جاري معالجة التصويت...', style: TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        ),
      );
    }

    if (_currentVoterIndex >= alivePlayers.length) {
      return Scaffold(
        backgroundColor: AppTheme.primaryDark,
        body: Center(child: CircularProgressIndicator(color: AppTheme.bloodRed)),
      );
    }

    final currentVoter = alivePlayers[_currentVoterIndex];
    final voteTargets = alivePlayers.where((p) => p.id != currentVoter.id).toList();

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text('المصوت ${_currentVoterIndex + 1} من ${alivePlayers.length}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // رسالة تمرير الجهاز
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
                const Icon(Icons.visibility_off, color: AppTheme.goldAccent, size: 30),
                const SizedBox(height: 8),
                Text(
                  'مرر الجهاز إلى: ${currentVoter.name}',
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${currentVoter.name} - اختر من تشتبه به',
            style: TextStyle(color: AppTheme.goldAccent, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // قائمة التصويت
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: voteTargets.length,
              itemBuilder: (context, index) {
                final target = voteTargets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      gameProvider.castVote(currentVoter.id, target.id);
                      setState(() => _currentVoterIndex++);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.cardDark,
                      foregroundColor: AppTheme.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: AppTheme.goldAccent),
                        const SizedBox(width: 12),
                        Text(target.name, style: const TextStyle(fontSize: 18)),
                        const Spacer(),
                        const Icon(Icons.how_to_vote, color: AppTheme.bloodRed),
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