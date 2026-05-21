import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';
// ✅ شيل import game_engine.dart - استخدم GamePhase من provider فقط
import '../widgets/evidence_card.dart';
import '../widgets/discussion_timer.dart';
import '../widgets/alive_players_grid.dart';
import '../../data/models/player_model.dart'; // ✅ استيراد Player

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
            colors: [
              AppTheme.primaryDark,
              AppTheme.secondaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              if (gameProvider.isPhaseTransitioning) {
                return _buildTransitionEffect();
              }
              return _buildPhaseContent(gameProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTransitionEffect() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 2 * 3.14159),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Transform.rotate(
            angle: value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.goldAccent.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.search,
                  color: AppTheme.goldAccent,
                  size: 30,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ استخدم if بدل switch لتجنب مشاكل const
  Widget _buildPhaseContent(GameProvider gameProvider) {
    final phase = gameProvider.currentPhase;
    
    if (phase == GamePhase.evidencePhase) {
      return _buildEvidencePhase(gameProvider);
    } else if (phase == GamePhase.discussion) {
      return _buildDiscussionPhase(gameProvider);
    } else if (phase == GamePhase.voting) {
      return _buildVotingPhase(gameProvider);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildEvidencePhase(GameProvider gameProvider) {
    return Column(
      children: [
        _buildHeader(gameProvider),
        Expanded(
          child: gameProvider.currentEvidence != null
              ? EvidenceCard(evidence: gameProvider.currentEvidence!)
              : const Center(
                  child: Text('لا مزيد من الأدلة',
                      style: TextStyle(color: AppTheme.textSecondary)),
                ),
        ),
        _buildSuspicionMeter(gameProvider.suspicionLevel),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              if (gameProvider.currentEvidence != null) {
                gameProvider.nextEvidence();
              } else {
                gameProvider.startDiscussion();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bloodRed,
              foregroundColor: AppTheme.goldAccent,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              gameProvider.currentEvidence != null
                  ? 'الدليل التالي'
                  : 'ابدأ المناقشة',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscussionPhase(GameProvider gameProvider) {
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
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        const Spacer(),
        AlivePlayersGrid(players: gameProvider.alivePlayers),
        const Spacer(),
        const DiscussionTimer(duration: 120),
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

  Widget _buildVotingPhase(GameProvider gameProvider) {
    return Column(
      children: [
        _buildHeader(gameProvider),
        const SizedBox(height: 20),
        Text(
          '🗳️ وقت التصويت',
          style: TextStyle(
            color: AppTheme.goldAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildSuspicionMeter(gameProvider.suspicionLevel),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: gameProvider.alivePlayers.length,
            itemBuilder: (context, index) {
              final player = gameProvider.alivePlayers[index];
              return _buildVoteCard(player);
            },
          ),
        ),
      ],
    );
  }

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
            builder: (context, child) {
              return Transform.scale(
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
              );
            },
          ),
        ],
      ),
    );
  }

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

  // ✅ استخدم Player من data/models
  Widget _buildVoteCard(Player player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.bloodRed.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.bloodRed.withOpacity(0.2),
            ),
            child: const Icon(Icons.person, color: AppTheme.goldAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player.name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<GameProvider>().castVote('current', player.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم التصويت ضد ${player.name}'),
                  backgroundColor: AppTheme.bloodRed,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.goldAccent),
              ),
              child: const Icon(
                Icons.how_to_vote,
                color: AppTheme.goldAccent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}