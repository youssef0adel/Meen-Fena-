import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';
import '../../game/engine/game_engine.dart';
import '../widgets/evidence_card.dart';
import '../widgets/discussion_timer.dart';
import '../widgets/alive_players_grid.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              return _buildPhaseContent(gameProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseContent(GameProvider gameProvider) {
    switch (gameProvider.currentPhase) {
      case GamePhase.evidencePhase:
        return _buildEvidencePhase(gameProvider);
      case GamePhase.discussion:
        return _buildDiscussionPhase(gameProvider);
      case GamePhase.voting:
        return _buildVotingPhase(gameProvider);
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildEvidencePhase(GameProvider gameProvider) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Round ${gameProvider.currentRound + 1}',
                    style: TextStyle(
                      color: AppTheme.goldAccent,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentRed),
                    ),
                    child: Text(
                      'EVIDENCE',
                      style: TextStyle(
                        color: AppTheme.accentRed,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                gameProvider.currentCase?.title ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Evidence Card
        Expanded(
          child: Center(
            child: gameProvider.currentEvidence != null
                ? EvidenceCard(evidence: gameProvider.currentEvidence!)
                : const Text('No more evidence'),
          ),
        ),
        // Next Button
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
              minimumSize: const Size(double.infinity, 56),
            ),
            child: Text(
              gameProvider.currentEvidence != null
                  ? 'NEXT EVIDENCE'
                  : 'START DISCUSSION',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscussionPhase(GameProvider gameProvider) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'DISCUSSION PHASE',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Text(
          'Discuss the evidence and defend yourself',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        const Spacer(),
        // Alive players grid
        AlivePlayersGrid(players: gameProvider.alivePlayers),
        const Spacer(),
        // Discussion Timer
        const DiscussionTimer(duration: 120), // 2 minutes
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/voting');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('PROCEED TO VOTING'),
          ),
        ),
      ],
    );
  }

  Widget _buildVotingPhase(GameProvider gameProvider) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'TIME TO VOTE',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Who do you think is the mafia?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: gameProvider.alivePlayers.length,
            itemBuilder: (context, index) {
              final player = gameProvider.alivePlayers[index];
              final character = gameProvider.currentCase?.suspects.firstWhere(
                (c) => c.id == player.characterId,
              );
              
              return GestureDetector(
                onTap: () {
                  // Navigate to voting screen or handle vote
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.accentRed.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppTheme.textSecondary,
                        size: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              character?.occupation ?? '',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.accentRed,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'VOTE',
                            style: TextStyle(
                              color: AppTheme.accentRed,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}