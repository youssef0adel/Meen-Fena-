import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';

class RoleRevealScreen extends StatefulWidget {
  const RoleRevealScreen({super.key});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;
  int _currentPlayerIndex = 0;
  bool _roleRevealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _revealRole() {
    setState(() {
      _roleRevealed = true;
    });
    _controller.forward();
  }

  void _nextPlayer() {
    final gameProvider = context.read<GameProvider>();
    if (_currentPlayerIndex < gameProvider.players.length - 1) {
      setState(() {
        _currentPlayerIndex++;
        _roleRevealed = false;
      });
      _controller.reset();
    } else {
      Navigator.pushReplacementNamed(context, '/game');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final currentPlayer = gameProvider.players[_currentPlayerIndex];
    final character = gameProvider.currentCase?.suspects.firstWhere(
      (c) => c.id == currentPlayer.characterId,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              _roleRevealed && currentPlayer.isMafia
                  ? AppTheme.bloodRed
                  : AppTheme.secondaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Player ${_currentPlayerIndex + 1}',
                style: TextStyle(
                  color: AppTheme.goldAccent,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                currentPlayer.name,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 36,
                    ),
              ),
              const SizedBox(height: 20),
              // Pass the device message
              if (!_roleRevealed)
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.accentRed, width: 2),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.visibility_off,
                        size: 48,
                        color: AppTheme.accentRed,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Pass the device to',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Ensure no one else sees the screen',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              if (!_roleRevealed)
                ElevatedButton.icon(
                  onPressed: _revealRole,
                  icon: const Icon(Icons.visibility),
                  label: const Text('REVEAL ROLE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                  ),
                ),
              if (_roleRevealed) ...[
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      // Character profile card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: currentPlayer.isMafia
                                ? AppTheme.mafiaRed
                                : AppTheme.innocentBlue,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: currentPlayer.isMafia
                                  ? AppTheme.mafiaRed.withOpacity(0.3)
                                  : AppTheme.innocentBlue.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              character?.name ?? '',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${character?.age} years • ${character?.occupation}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: 40,
                              height: 2,
                              color: AppTheme.accentRed,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              character?.background ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Role reveal
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: currentPlayer.isMafia
                                    ? AppTheme.mafiaRed.withOpacity(0.2)
                                    : AppTheme.innocentBlue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: currentPlayer.isMafia
                                      ? AppTheme.mafiaRed
                                      : AppTheme.innocentBlue,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    currentPlayer.isMafia
                                        ? Icons.dangerous
                                        : Icons.shield,
                                    color: currentPlayer.isMafia
                                        ? AppTheme.mafiaRed
                                        : AppTheme.innocentBlue,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    currentPlayer.isMafia
                                        ? 'MAFIA'
                                        : 'INNOCENT',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: currentPlayer.isMafia
                                          ? AppTheme.mafiaRed
                                          : AppTheme.innocentBlue,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (currentPlayer.isMafia) ...[
                              const SizedBox(height: 20),
                              Text(
                                'Your partner is: [REDACTED]',
                                style: TextStyle(
                                  color: AppTheme.mafiaRed.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _nextPlayer,
                        child: Text(
                          _currentPlayerIndex < gameProvider.players.length - 1
                              ? 'NEXT PLAYER'
                              : 'START GAME',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}