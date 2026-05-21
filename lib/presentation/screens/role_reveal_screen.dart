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

class _RoleRevealScreenState extends State<RoleRevealScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _revealAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _shakeAnimation;
  int _currentPlayerIndex = 0;
  bool _roleRevealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _revealRole() {
    setState(() => _roleRevealed = true);
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
            colors: _roleRevealed && currentPlayer.isMafia
                ? [AppTheme.primaryDark, AppTheme.bloodRed, AppTheme.primaryDark]
                : [AppTheme.primaryDark, AppTheme.cardDark, AppTheme.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // رقم اللاعب
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.goldAccent.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'لاعب ${_currentPlayerIndex + 1} من ${gameProvider.players.length}',
                  style: TextStyle(
                    color: AppTheme.goldAccent,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // اسم اللاعب
              Text(
                currentPlayer.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 30),
              
              if (!_roleRevealed)
                // رسالة التمرير
                _buildPassDeviceMessage(),
              
              if (_roleRevealed)
                // كارت الشخصية
                _buildCharacterCard(character, currentPlayer),
              
              const Spacer(),
              
              // زر الكشف أو التالي
              Padding(
                padding: const EdgeInsets.all(20),
                child: _buildActionButton(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassDeviceMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.bloodRed.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.bloodRed.withOpacity(0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // أيقونة متحركة
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 2 * 3.14159),
            duration: const Duration(seconds: 3),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value,
                child: child,
              );
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.goldAccent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.bloodRed.withOpacity(0.2),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.visibility_off,
                color: AppTheme.goldAccent,
                size: 35,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'مرر الجهاز إلى',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            currentPlayer.name,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'تأكد أن لا أحد يرى الشاشة',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(character, currentPlayer) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shakeOffset = sin(_shakeAnimation.value * 6) * 8;
        
        return Transform.translate(
          offset: Offset(
            _revealAnimation.value < 0.5 ? shakeOffset : 0,
            0,
          ),
          child: Opacity(
            opacity: _revealAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: currentPlayer.isMafia
                      ? AppTheme.mafiaRed.withOpacity(0.5)
                      : AppTheme.goldAccent.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentPlayer.isMafia
                        ? AppTheme.mafiaRed.withOpacity(_glowAnimation.value * 0.4)
                        : AppTheme.goldAccent.withOpacity(_glowAnimation.value * 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // صورة الشخصية
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          currentPlayer.isMafia
                              ? AppTheme.mafiaRed.withOpacity(0.3)
                              : AppTheme.cardLight,
                          currentPlayer.isMafia
                              ? AppTheme.bloodRed.withOpacity(0.5)
                              : AppTheme.cardDark,
                        ],
                      ),
                      border: Border.all(
                        color: currentPlayer.isMafia
                            ? AppTheme.mafiaRed
                            : AppTheme.goldAccent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      currentPlayer.isMafia ? Icons.masks : Icons.person,
                      color: currentPlayer.isMafia
                          ? AppTheme.mafiaRed
                          : AppTheme.goldAccent,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // اسم الشخصية
                  Text(
                    character?.name ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${character?.age ?? ""} سنة • ${character?.occupation ?? ""}',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // خلفية الشخصية
                  Text(
                    character?.background ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // بطاقة الدور
                  _buildRoleBadge(currentPlayer),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleBadge(currentPlayer) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: currentPlayer.isMafia
            ? AppTheme.mafiaRed.withOpacity(0.2)
            : AppTheme.innocentBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: currentPlayer.isMafia
              ? AppTheme.mafiaRed
              : AppTheme.innocentBlue,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: currentPlayer.isMafia
                ? AppTheme.mafiaRed.withOpacity(_glowAnimation.value * 0.3)
                : AppTheme.innocentBlue.withOpacity(_glowAnimation.value * 0.2),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            currentPlayer.isMafia ? Icons.dangerous : Icons.shield,
            color: currentPlayer.isMafia
                ? AppTheme.mafiaRed
                : AppTheme.innocentBlue,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            currentPlayer.isMafia ? 'مافيا 🔪' : 'بريء 🛡️',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: currentPlayer.isMafia
                  ? AppTheme.mafiaRed
                  : AppTheme.innocentBlue,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (!_roleRevealed) {
      return ElevatedButton.icon(
        onPressed: _revealRole,
        icon: const Icon(Icons.visibility),
        label: const Text('اكشف الدور'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.bloodRed,
          foregroundColor: AppTheme.goldAccent,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: _nextPlayer,
        icon: Icon(
          _currentPlayerIndex < context.read<GameProvider>().players.length - 1
              ? Icons.arrow_forward
              : Icons.play_arrow,
        ),
        label: Text(
          _currentPlayerIndex < context.read<GameProvider>().players.length - 1
              ? 'اللاعب التالي'
              : 'ابدأ اللعبة',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.goldDark,
          foregroundColor: AppTheme.primaryDark,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      );
    }
  }
}