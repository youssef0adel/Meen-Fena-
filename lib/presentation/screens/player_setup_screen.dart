import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';
import '../widgets/player_name_card.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  int _playerCount = 4;
  final List<TextEditingController> _nameControllers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    _nameControllers.clear();
    for (int i = 0; i < _playerCount; i++) {
      _nameControllers.add(TextEditingController(text: 'لاعب ${i + 1}'));
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // ✅ إصلاح دالة البدء
  void _startGame() {
    if (_formKey.currentState!.validate()) {
      final playerNames = _nameControllers
          .map((controller) => controller.text.trim())
          .toList();

      // ✅ تحقق من الأسماء
      if (playerNames.any((name) => name.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('من فضلك أدخل جميع أسماء اللاعبين'),
            backgroundColor: AppTheme.bloodRed,
          ),
        );
        return;
      }

      final gameProvider = context.read<GameProvider>();
      
      // ✅ تهيئة اللعبة
      gameProvider.initializeGame(playerNames);
      gameProvider.selectCase();
      gameProvider.assignRoles();

      // ✅ الانتقال مباشرة بدون تأخير طويل
      Navigator.pushNamed(context, '/role-reveal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text(
          'إعداد اللاعبين',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryDark, AppTheme.secondaryDark],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'اختر عدد اللاعبين',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlayerCountChip(4),
                  const SizedBox(width: 8),
                  _buildPlayerCountChip(5),
                  const SizedBox(width: 8),
                  _buildPlayerCountChip(6),
                  const SizedBox(width: 8),
                  _buildPlayerCountChip(7),
                  const SizedBox(width: 8),
                  _buildPlayerCountChip(8),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _playerCount,
                  itemBuilder: (context, index) {
                    return PlayerNameCard(
                      playerNumber: index + 1,
                      controller: _nameControllers[index],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.bloodRed,
                      foregroundColor: AppTheme.goldAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    child: const Text('🔍 ابدأ اللعبة'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCountChip(int count) {
    final isSelected = _playerCount == count;
    return GestureDetector(
      onTap: () {
        setState(() {
          _playerCount = count;
          _initializeControllers();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.bloodRed : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.goldAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          '$count',
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}