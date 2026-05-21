import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/menu_button.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});
  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _slideAnimation = Tween<double>(begin: 80, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.primaryDark, AppTheme.secondaryDark, AppTheme.primaryDark])),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) => Opacity(opacity: _controller.value, child: Transform.translate(offset: Offset(0, _slideAnimation.value), child: child)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(colors: [AppTheme.goldAccent, AppTheme.bloodRedLight]).createShader(bounds),
                  child: const Text('مين فينا؟', style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4)),
                ),
                const SizedBox(height: 12),
                Text('WHO AMONG US?', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, letterSpacing: 8)),
                const Spacer(flex: 2),
                MenuButton(icon: Icons.people_outline, label: 'لعبة جديدة', description: 'تمرير الجهاز بين اللاعبين', onTap: () => Navigator.pushNamed(context, '/player-setup')),
                const SizedBox(height: 14),
                MenuButton(icon: Icons.wifi, label: 'شبكة محلية', description: 'لعب جماعي عبر أجهزة متعددة', onTap: () => Navigator.pushNamed(context, '/lan-game')),
                const SizedBox(height: 14),
                MenuButton(icon: Icons.settings_outlined, label: 'الإعدادات', description: 'خيارات اللعبة والقواعد', onTap: () => Navigator.pushNamed(context, '/settings')),
                const Spacer(flex: 3),
                Text('🔍 كل الأدلة... لا أحد بريء', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, letterSpacing: 2)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}