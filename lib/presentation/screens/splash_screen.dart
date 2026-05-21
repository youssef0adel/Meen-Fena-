import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/menu');
    });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(center: Alignment.center, radius: 1.5, colors: [AppTheme.cardDark, AppTheme.primaryDark, AppTheme.primaryDark]),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.goldAccent, width: 2), boxShadow: [BoxShadow(color: AppTheme.bloodRed.withOpacity(0.3), blurRadius: 30)]),
                    child: const Icon(Icons.search, size: 50, color: AppTheme.goldAccent),
                  ),
                  const SizedBox(height: 40),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [AppTheme.goldAccent, AppTheme.bloodRedLight, AppTheme.goldDark]).createShader(bounds),
                    child: const Text('مين فينا؟', style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 6, shadows: [Shadow(color: AppTheme.bloodRed, blurRadius: 20)])),
                  ),
                  const SizedBox(height: 16),
                  Text('WHO AMONG US?', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary, letterSpacing: 8)),
                  const SizedBox(height: 40),
                  SizedBox(width: 30, height: 30, child: CircularProgressIndicator(color: AppTheme.bloodRedLight, strokeWidth: 2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}