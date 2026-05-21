import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';
import '../../data/models/player_model.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});
  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int _currentVoterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final alivePlayers = gameProvider.alivePlayers;

    if (_currentVoterIndex >= alivePlayers.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameProvider.processElimination();
        if (gameProvider.currentPhase == GamePhase.evidencePhase || gameProvider.currentPhase == GamePhase.discussion) {
          Navigator.pushReplacementNamed(context, '/game');
        } else {
          Navigator.pushReplacementNamed(context, '/endgame');
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentVoter = alivePlayers[_currentVoterIndex];
    final voteTargets = alivePlayers.where((p) => p.id != currentVoter.id).toList();

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(title: Text('التصويت - المصوت ${_currentVoterIndex + 1} من ${alivePlayers.length}'), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: Column(children: [
        const SizedBox(height: 20),
        Container(margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.goldAccent.withOpacity(0.3))), child: Column(children: [const Icon(Icons.visibility_off, color: AppTheme.goldAccent, size: 30), const SizedBox(height: 8), Text('مرر الجهاز إلى: ${currentVoter.name}', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold))])),
        const SizedBox(height: 20),
        Text('${currentVoter.name} - اختر من تشتبه به', style: TextStyle(color: AppTheme.goldAccent, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: voteTargets.length, itemBuilder: (context, index) {
          final target = voteTargets[index];
          return Container(margin: const EdgeInsets.only(bottom: 10), child: ElevatedButton(
            onPressed: () { gameProvider.castVote(currentVoter.id, target.id); setState(() => _currentVoterIndex++); },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.cardDark, foregroundColor: AppTheme.textPrimary, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Row(children: [const Icon(Icons.person, color: AppTheme.goldAccent), const SizedBox(width: 12), Text(target.name, style: const TextStyle(fontSize: 18)), const Spacer(), const Icon(Icons.how_to_vote, color: AppTheme.bloodRed)]),
          ));
        })),
      ]),
    );
  }
}