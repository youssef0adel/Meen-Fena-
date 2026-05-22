import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/evidence_card.dart';
import '../widgets/discussion_timer.dart';
import '../widgets/alive_players_grid.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primaryDark, AppTheme.secondaryDark],
          ),
        ),
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, child) =>
                _buildPhaseContent(gameProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseContent(GameProvider gameProvider) {
    final phase = gameProvider.currentPhase;
    if (phase == GamePhase.evidencePhase) {
      return _buildEvidencePhase(gameProvider);
    }
    if (phase == GamePhase.discussion) {
      return _buildDiscussionPhase(gameProvider);
    }
    return const Center(
      child: CircularProgressIndicator(color: AppTheme.bloodRed),
    );
  }

  // ========== مرحلة الأدلة ==========
  Widget _buildEvidencePhase(GameProvider gameProvider) {
    final currentEvidenceIndex = gameProvider.currentRound;
    final totalEvidence = gameProvider.currentCase?.evidenceCards.length ?? 1;

    return Column(
      children: [
        _buildHeader(gameProvider),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Text(
            'الدليل ${currentEvidenceIndex + 1} من $totalEvidence',
            style: TextStyle(
              color: AppTheme.goldAccent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: gameProvider.currentEvidence != null
              ? EvidenceCard(evidence: gameProvider.currentEvidence!)
              : const Center(
                  child: Text(
                    'لا مزيد من الأدلة',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
        ),

        _buildSuspicionMeter(gameProvider.suspicionLevel),

        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => gameProvider.goToDiscussion(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bloodRed,
                foregroundColor: AppTheme.goldAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'ابدأ المناقشة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========== مرحلة المناقشة ==========
  Widget _buildDiscussionPhase(GameProvider gameProvider) {
    // ✅ قراءة الوقت من AudioProvider
    final audioProvider = context.read<AudioProvider>();
    final discussionTime = audioProvider.discussionTime;

    return Column(
      children: [
        _buildHeader(gameProvider),
        const SizedBox(height: 20),

        Text(
          '🗣️ مرحلة المناقشة',
          style: TextStyle(
            color: AppTheme.goldAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'تناقشوا في الأدلة... لكن احذروا المخادعين',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),

        const Spacer(),

        AlivePlayersGrid(players: gameProvider.alivePlayers),

        const SizedBox(height: 20),

        // ✅ استخدام الوقت المحفوظ
        DiscussionTimer(duration: discussionTime),

        const SizedBox(height: 20),

        _buildSuspicionMeter(gameProvider.suspicionLevel),

        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              gameProvider.startVoting();
              Navigator.pushNamed(context, '/voting');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.mafiaRed,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'ابدأ التصويت 🗳️',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // ========== الهيدر ==========
  Widget _buildHeader(GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bloodRed.withOpacity(0.1),
            AppTheme.cardDark,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.bloodRed.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الجولة ${gameProvider.currentRound + 1}',
                style: TextStyle(
                  color: AppTheme.goldAccent,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                gameProvider.currentCase?.title ?? '',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.bloodRed.withOpacity(0.2),
                  border: Border.all(color: AppTheme.goldAccent),
                ),
                child: const Icon(
                  Icons.search,
                  color: AppTheme.goldAccent,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== شريط الشك ==========
  Widget _buildSuspicionMeter(double level) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: [
            AppTheme.bloodRed.withOpacity(level),
            AppTheme.goldAccent.withOpacity(level * 0.5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.bloodRed.withOpacity(level * 0.3),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}