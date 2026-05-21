import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/audio_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioProvider>();
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(title: const Text('الإعدادات', style: TextStyle(color: AppTheme.textPrimary)), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        _buildSection('الصوت والموسيقى'),
        _buildSwitch(context, Icons.music_note, 'موسيقى الخلفية', audioProvider.musicEnabled, (v) => audioProvider.toggleMusic()),
        if (audioProvider.musicEnabled) _buildSlider(context, 'مستوى الموسيقى', audioProvider.musicVolume, (v) => audioProvider.setMusicVolume(v)),
        _buildSwitch(context, Icons.volume_up, 'المؤثرات الصوتية', audioProvider.soundEffectsEnabled, (v) => audioProvider.toggleSoundEffects()),
        if (audioProvider.soundEffectsEnabled) _buildSlider(context, 'مستوى المؤثرات', audioProvider.sfxVolume, (v) => audioProvider.setSfxVolume(v)),
        const SizedBox(height: 30),
        _buildSection('قواعد اللعبة'),
        _buildRule('🎭', 'كل لاعب يحصل على دور سري (مافيا أو بريء)'),
        _buildRule('🃏', 'يتم كشف أدلة كل جولة لإثارة الشك'),
        _buildRule('💬', 'ناقش الأدلة ودافع عن نفسك'),
        _buildRule('🗳️', 'صوّت لإقصاء المشتبه بهم'),
        _buildRule('🎯', 'الأبرياء يفوزون بالقضاء على المافيا'),
      ]),
    );
  }

  Widget _buildSection(String title) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: const TextStyle(color: AppTheme.goldAccent, fontSize: 20, fontWeight: FontWeight.bold)));
  
  Widget _buildSwitch(BuildContext context, IconData icon, String title, bool value, Function(bool) onChanged) {
    return Container(margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(12)), child: SwitchListTile(secondary: Icon(icon, color: AppTheme.accentRed), title: Text(title, style: const TextStyle(color: AppTheme.textPrimary)), value: value, activeColor: AppTheme.accentRed, onChanged: onChanged));
  }

  Widget _buildSlider(BuildContext context, String title, double value, Function(double) onChanged) {
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: AppTheme.textPrimary)), Slider(value: value, onChanged: onChanged, activeColor: AppTheme.accentRed, min: 0.0, max: 1.0)]));
  }

  Widget _buildRule(String emoji, String text) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5)))]));
}