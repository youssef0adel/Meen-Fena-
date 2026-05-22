import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'lan_lobby_screen.dart';

// ✅ شاشة اختيار وضع LAN
class LANGameScreen extends StatelessWidget {
  const LANGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('الشبكة المحلية', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi, color: AppTheme.goldAccent, size: 60),
              const SizedBox(height: 30),
              const Text(
                'اللعب عبر الشبكة المحلية',
                style: TextStyle(
                  color: AppTheme.goldAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // ✅ زر الاستضافة
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LANLobbyScreen(isHost: true),
                      ),
                    );
                  },
                  icon: const Icon(Icons.wifi),
                  label: const Text('استضافة لعبة جديدة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bloodRed,
                    foregroundColor: AppTheme.goldAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ زر الانضمام
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showJoinDialog(context);
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('انضمام للعبة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cardDark,
                    foregroundColor: AppTheme.goldAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppTheme.goldAccent.withOpacity(0.3)),
                    ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'تأكد من اتصال جميع الأجهزة بنفس شبكة WiFi',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    final ipController = TextEditingController(text: '192.168.1.');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('انضمام للعبة', style: TextStyle(color: AppTheme.goldAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أدخل IP السيرفر:', style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            TextField(
              controller: ipController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: '192.168.1.100',
                hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5)),
                filled: true,
                fillColor: AppTheme.secondaryDark,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final ip = ipController.text.trim();
              Navigator.pop(context);
              if (ip.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LANLobbyScreen(isHost: false, hostIp: ip),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.bloodRed),
            child: const Text('اتصال'),
          ),
        ],
      ),
    );
  }
}