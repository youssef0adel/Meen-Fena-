import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/menu_button.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              AppTheme.bloodRed.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: child,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                
                // العنوان الرئيسي
                const Text(
                  'مين فينا؟',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.goldAccent,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                
                // خط فاصل
                Container(
                  width: 60,
                  height: 2,
                  color: AppTheme.accentRed,
                ),
                const SizedBox(height: 20),
                
                // العنوان الإنجليزي
                Text(
                  'WHO AMONG US?',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    letterSpacing: 6,
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // زر لعبة جديدة
                MenuButton(
                  icon: Icons.people,
                  label: 'لعبة جديدة',
                  description: 'تمرير الجهاز بين اللاعبين',
                  onTap: () {
                    Navigator.pushNamed(context, '/player-setup');
                  },
                ),
                const SizedBox(height: 16),
                
                // زر LAN Multiplayer
                MenuButton(
                  icon: Icons.wifi,
                  label: 'شبكة محلية',
                  description: 'لعب جماعي عبر أجهزة متعددة',
                  onTap: () {
                    Navigator.pushNamed(context, '/lan-game');
                  },
                ),
                const SizedBox(height: 16),
                
                // زر الإعدادات
                MenuButton(
                  icon: Icons.settings,
                  label: 'الإعدادات',
                  description: 'خيارات اللعبة والقواعد',
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                
                const Spacer(flex: 3),
                
                // رقم الإصدار
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}