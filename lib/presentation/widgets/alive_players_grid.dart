import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/player_model.dart';

class AlivePlayersGrid extends StatelessWidget {
  final List<Player> players;
  const AlivePlayersGrid({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('اللاعبون الأحياء', style: TextStyle(color: AppTheme.goldAccent, fontSize: 14, letterSpacing: 2)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: players.map((player) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.accentRed.withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.person, color: AppTheme.accentRed, size: 18), const SizedBox(width: 6), Text(player.name, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14))]))).toList()),
      ]),
    );
  }
}