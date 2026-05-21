import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';
import 'dart:math';

class RoleRevealScreen extends StatefulWidget {
  const RoleRevealScreen({super.key});
  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _revealAnimation;
  int _currentPlayerIndex = 0;
  bool _roleRevealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _revealRole() { setState(() => _roleRevealed = true); _controller.forward(); }

  void _nextPlayer() {
    final gameProvider = context.read<GameProvider>();
    if (_currentPlayerIndex < gameProvider.players.length - 1) {
      setState(() { _currentPlayerIndex++; _roleRevealed = false; });
      _controller.reset();
    } else {
      Navigator.pushReplacementNamed(context, '/case-intro');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    if (gameProvider.players.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushReplacementNamed(context, '/menu'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final currentPlayer = gameProvider.players[_currentPlayerIndex];
    final character = gameProvider.currentCase?.suspects.firstWhere((c) => c.id == currentPlayer.characterId, orElse: () => gameProvider.currentCase!.suspects.first);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('لاعب ${_currentPlayerIndex + 1} من ${gameProvider.players.length}', style: TextStyle(color: AppTheme.goldAccent, fontSize: 16)),
            const SizedBox(height: 16),
            Text(currentPlayer.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 30),
            Expanded(child: _roleRevealed ? _buildCharacterCard(character, currentPlayer) : _buildPassMessage(currentPlayer.name)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton(
                onPressed: _roleRevealed ? _nextPlayer : _revealRole,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.bloodRed, foregroundColor: AppTheme.goldAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                child: Text(_roleRevealed ? (_currentPlayerIndex < gameProvider.players.length - 1 ? 'اللاعب التالي' : 'عرض الجريمة') : 'اكشف الدور'),
              )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPassMessage(String playerName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30), padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.goldAccent.withOpacity(0.3))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.visibility_off, color: AppTheme.goldAccent, size: 50),
        const SizedBox(height: 20),
        const Text('مرر الجهاز إلى', style: TextStyle(color: AppTheme.textSecondary, fontSize: 18)),
        const SizedBox(height: 8),
        Text(playerName, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildCharacterCard(character, currentPlayer) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _revealAnimation,
        builder: (context, child) => Opacity(
          opacity: _revealAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: currentPlayer.isMafia ? AppTheme.mafiaRed.withOpacity(0.5) : AppTheme.goldAccent.withOpacity(0.3), width: 2)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: currentPlayer.isMafia ? AppTheme.mafiaRed.withOpacity(0.3) : AppTheme.goldAccent.withOpacity(0.2), border: Border.all(color: currentPlayer.isMafia ? AppTheme.mafiaRed : AppTheme.goldAccent, width: 2)), child: Icon(currentPlayer.isMafia ? Icons.masks : Icons.person, color: currentPlayer.isMafia ? AppTheme.mafiaRed : AppTheme.goldAccent, size: 30)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(character?.name ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: currentPlayer.isMafia ? AppTheme.mafiaRed.withOpacity(0.2) : AppTheme.innocentBlue.withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: Text(currentPlayer.isMafia ? 'مافيا' : 'بريء', style: TextStyle(fontSize: 12, color: currentPlayer.isMafia ? AppTheme.mafiaRed : AppTheme.innocentBlue, fontWeight: FontWeight.bold))),
                ])),
              ]),
              const Divider(color: AppTheme.textMuted, height: 30),
              _buildDetailRow('العمر', '${character?.age ?? ""} سنة'),
              const SizedBox(height: 10),
              _buildDetailRow('المهنة', character?.occupation ?? ''),
              const SizedBox(height: 10),
              _buildDetailRow('السمات', character?.personalityTraits?.join('، ') ?? ''),
              const SizedBox(height: 10),
              _buildDetailRow('الخلفية', character?.background ?? ''),
              const SizedBox(height: 10),
              _buildDetailRow('الدافع', character?.hiddenMotivation ?? ''),
              const SizedBox(height: 10),
              _buildDetailRow('العلاقة', character?.connectionToVictim ?? ''),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 80, child: Text(label, style: const TextStyle(color: AppTheme.goldAccent, fontSize: 13, fontWeight: FontWeight.bold))),
      Expanded(child: Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, height: 1.4))),
    ]);
  }
}