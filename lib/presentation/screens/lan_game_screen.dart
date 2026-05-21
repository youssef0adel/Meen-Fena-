import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LANGameScreen extends StatelessWidget {
  const LANGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(title: const Text('شبكة محلية', style: TextStyle(color: AppTheme.textPrimary)), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.wifi, color: AppTheme.goldAccent, size: 60), const SizedBox(height: 20), Text('قريباً...', style: TextStyle(color: AppTheme.goldAccent, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text('طور اللعب الجماعي عبر الشبكة المحلية', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14))])),
    );
  }
}