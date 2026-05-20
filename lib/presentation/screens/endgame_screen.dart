import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EndgameScreen extends StatelessWidget {
  const EndgameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎉 انتهت اللعبة!',
              style: TextStyle(color: AppTheme.goldAccent, fontSize: 32),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
              },
              child: const Text('العودة للقائمة'),
            ),
          ],
        ),
      ),
    );
  }
}