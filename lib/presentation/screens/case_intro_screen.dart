import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';

class CaseIntroScreen extends StatelessWidget {
  const CaseIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final gameCase = gameProvider.currentCase;
    if (gameCase == null) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.bloodRed)));

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(border: Border.all(color: AppTheme.bloodRed), borderRadius: BorderRadius.circular(8)), child: const Text('📋 تفاصيل الجريمة', style: TextStyle(color: AppTheme.goldAccent, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2))),
            const SizedBox(height: 24),
            Text(gameCase.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 16),
            Container(width: 60, height: 2, color: AppTheme.bloodRed),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.bloodRed.withOpacity(0.3))), child: Column(children: [
              _buildInfoRow('📍 المكان', gameCase.location),
              const SizedBox(height: 12),
              _buildInfoRow('🕐 الوقت', gameCase.timeOfCrime),
              const SizedBox(height: 12),
              _buildInfoRow('👤 المجني عليه', gameCase.victimName),
              const SizedBox(height: 12),
              _buildInfoRow('📝 معلومات', gameCase.victimProfile),
            ])),
            const SizedBox(height: 20),
            Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.goldAccent.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('وصف الجريمة:', style: TextStyle(color: AppTheme.goldAccent, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Directionality(textDirection: TextDirection.rtl, child: Text(gameCase.description, textAlign: TextAlign.right, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15, height: 1.8))),
            ])),
            const SizedBox(height: 20),
            Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.bloodRed.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('المشتبه بهم:', style: TextStyle(color: AppTheme.goldAccent, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...gameCase.suspects.map((suspect) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(textDirection: TextDirection.rtl, children: [const Icon(Icons.person, color: AppTheme.bloodRed, size: 20), const SizedBox(width: 8), Expanded(child: Text('${suspect.name} - ${suspect.occupation}', textDirection: TextDirection.rtl, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)))])),
              ),
            ])),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(
              onPressed: () { gameProvider.startEvidencePhase(); Navigator.pushReplacementNamed(context, '/game'); },
              icon: const Icon(Icons.search), label: const Text('ابدأ التحقيق'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.bloodRed, foregroundColor: AppTheme.goldAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(textDirection: TextDirection.rtl, crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 100, child: Text(label, textDirection: TextDirection.rtl, style: const TextStyle(color: AppTheme.goldAccent, fontSize: 14, fontWeight: FontWeight.bold))),
      Expanded(child: Text(value, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14))),
    ]);
  }
}