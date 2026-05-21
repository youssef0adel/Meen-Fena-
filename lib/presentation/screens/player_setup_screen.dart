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
  void initState() { super.initState(); _initControllers(); }

  void _initControllers() {
    for (var c in _nameControllers) { c.dispose(); }
    _nameControllers.clear();
    for (int i = 0; i < _playerCount; i++) { _nameControllers.add(TextEditingController(text: 'لاعب ${i + 1}')); }
  }

  @override
  void dispose() { for (var c in _nameControllers) { c.dispose(); } super.dispose(); }

  void _startGame() {
    final names = _nameControllers.map((c) => c.text.trim()).toList();
    if (names.any((n) => n.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل جميع الأسماء')));
      return;
    }
    final gp = context.read<GameProvider>();
    gp.initializeGame(names);
    gp.selectCase();
    gp.assignRoles();
    Navigator.pushNamed(context, '/role-reveal');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(title: const Text('إعداد اللاعبين', style: TextStyle(color: AppTheme.textPrimary)), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [4, 5, 6, 7, 8].map((count) {
              final sel = _playerCount == count;
              return Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: GestureDetector(
                onTap: () { setState(() { _playerCount = count; _initControllers(); }); },
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: sel ? AppTheme.bloodRed : AppTheme.cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: sel ? AppTheme.goldAccent : Colors.transparent, width: 2)), child: Text('$count', style: TextStyle(color: sel ? Colors.white : AppTheme.textSecondary, fontSize: 18, fontWeight: FontWeight.bold))),
              ));
            }).toList()),
            const SizedBox(height: 16),
            Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: _playerCount, itemBuilder: (_, i) => PlayerNameCard(playerNumber: i + 1, controller: _nameControllers[i]))),
            Padding(padding: const EdgeInsets.all(20), child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: _startGame, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.bloodRed, foregroundColor: AppTheme.goldAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), child: const Text('🔍 ابدأ اللعبة')))),
          ],
        ),
      ),
    );
  }
}