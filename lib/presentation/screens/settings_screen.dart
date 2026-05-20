import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/audio_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'ar';
  int _discussionTime = 120;
  int _votingTime = 60;

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryDark, AppTheme.secondaryDark],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Language Settings
            _buildSectionHeader('اللغة والتوطين'),
            _buildLanguageSelector(),
            const SizedBox(height: 30),

            // Audio Settings
            _buildSectionHeader('الصوت والموسيقى'),
            _buildSwitchTile(
              icon: Icons.music_note,
              title: 'موسيقى الخلفية',
              value: audioProvider.musicEnabled,
              onChanged: (value) => audioProvider.toggleMusic(),
            ),
            if (audioProvider.musicEnabled) ...[
              _buildSliderTile(
                icon: Icons.volume_up,
                title: 'مستوى الموسيقى',
                value: audioProvider.musicVolume,
                onChanged: (value) => audioProvider.setMusicVolume(value),
              ),
            ],
            _buildSwitchTile(
              icon: Icons.volume_up,
              title: 'المؤثرات الصوتية',
              value: audioProvider.soundEffectsEnabled,
              onChanged: (value) => audioProvider.toggleSoundEffects(),
            ),
            if (audioProvider.soundEffectsEnabled) ...[
              _buildSliderTile(
                icon: Icons.surround_sound,
                title: 'مستوى المؤثرات',
                value: audioProvider.sfxVolume,
                onChanged: (value) => audioProvider.setSfxVolume(value),
              ),
            ],
            const SizedBox(height: 30),

            // Game Settings
            _buildSectionHeader('إعدادات اللعبة'),
            _buildTimeSelector(
              icon: Icons.timer,
              title: 'وقت المناقشة',
              value: _discussionTime,
              options: const [60, 90, 120, 180, 240],
              labels: const ['1 دقيقة', '1.5 دقيقة', '2 دقيقة', '3 دقائق', '4 دقائق'],
              onChanged: (value) {
                setState(() => _discussionTime = value);
              },
            ),
            const SizedBox(height: 16),
            _buildTimeSelector(
              icon: Icons.how_to_vote,
              title: 'وقت التصويت',
              value: _votingTime,
              options: const [30, 45, 60, 90, 120],
              labels: const ['30 ثانية', '45 ثانية', '1 دقيقة', '1.5 دقيقة', '2 دقيقة'],
              onChanged: (value) {
                setState(() => _votingTime = value);
              },
            ),
            const SizedBox(height: 30),

            // Game Rules
            _buildSectionHeader('قواعد اللعبة'),
            _buildRulesCard(),
            const SizedBox(height: 30),

            // About
            _buildSectionHeader('حول التطبيق'),
            _buildAboutCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.goldAccent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text('🇪🇬 العربية (Arabic)',
                style: TextStyle(color: AppTheme.textPrimary)),
            value: 'ar',
            groupValue: _selectedLanguage,
            activeColor: AppTheme.accentRed,
            onChanged: (value) {
              setState(() => _selectedLanguage = value!);
            },
          ),
          RadioListTile<String>(
            title: const Text('🇬🇧 English',
                style: TextStyle(color: AppTheme.textPrimary)),
            value: 'en',
            groupValue: _selectedLanguage,
            activeColor: AppTheme.accentRed,
            onChanged: (value) {
              setState(() => _selectedLanguage = value!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppTheme.accentRed),
        title: Text(title, style: const TextStyle(color: AppTheme.textPrimary)),
        value: value,
        activeColor: AppTheme.accentRed,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required double value,
    required Function(double) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.accentRed, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AppTheme.textPrimary)),
              const Spacer(),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accentRed,
            min: 0.0,
            max: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required IconData icon,
    required String title,
    required int value,
    required List<int> options,
    required List<String> labels,
    required Function(int) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.accentRed),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AppTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: List.generate(options.length, (index) {
              final isSelected = value == options[index];
              return ChoiceChip(
                label: Text(labels[index]),
                selected: isSelected,
                selectedColor: AppTheme.accentRed,
                backgroundColor: AppTheme.secondaryDark,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
                onSelected: (selected) {
                  if (selected) onChanged(options[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentRed.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRuleItem('🎭', 'كل لاعب يحصل على دور سري (مافيا أو بريء)'),
          const SizedBox(height: 8),
          _buildRuleItem('🃏', 'يتم كشف أدلة كل جولة لإثارة الشك'),
          const SizedBox(height: 8),
          _buildRuleItem('💬', 'ناقش الأدلة ودافع عن نفسك'),
          const SizedBox(height: 8),
          _buildRuleItem('🗳️', 'صوّت لإقصاء المشتبه بهم'),
          const SizedBox(height: 8),
          _buildRuleItem('🎯', 'الأبرياء يفوزون بالقضاء على المافيا'),
          const SizedBox(height: 8),
          _buildRuleItem('⚖️', 'إذا تبقى لاعبان، هيئة المحلفين تقرر'),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Text(
            'مين فينا؟',
            style: TextStyle(
              color: AppTheme.goldAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Who Among Us?',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'الإصدار 1.0.0',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            '© 2024 جميع الحقوق محفوظة',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}