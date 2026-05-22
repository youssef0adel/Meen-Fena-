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
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ========== الصوت ==========
          _buildSectionTitle('🔊 الصوت والموسيقى'),
          const SizedBox(height: 12),

          // موسيقى الخلفية
          _buildSwitchCard(
            icon: Icons.music_note,
            title: 'موسيقى الخلفية',
            value: audioProvider.musicEnabled,
            onChanged: (v) => audioProvider.toggleMusic(),
          ),
          if (audioProvider.musicEnabled)
            _buildSliderCard(
              icon: Icons.volume_up,
              title: 'مستوى الموسيقى',
              value: audioProvider.musicVolume,
              onChanged: (v) => audioProvider.setMusicVolume(v),
            ),

          // مؤثرات صوتية
          _buildSwitchCard(
            icon: Icons.surround_sound,
            title: 'المؤثرات الصوتية',
            value: audioProvider.soundEffectsEnabled,
            onChanged: (v) => audioProvider.toggleSoundEffects(),
          ),
          if (audioProvider.soundEffectsEnabled)
            _buildSliderCard(
              icon: Icons.graphic_eq,
              title: 'مستوى المؤثرات',
              value: audioProvider.sfxVolume,
              onChanged: (v) => audioProvider.setSfxVolume(v),
            ),

          const SizedBox(height: 30),

          // ========== وقت اللعبة ==========
          _buildSectionTitle('⏱️ وقت اللعبة'),
          const SizedBox(height: 12),

          // وقت المناقشة
          _buildTimeCard(
            icon: Icons.timer,
            title: 'وقت المناقشة',
            selected: audioProvider.discussionTime,
            options: const [60, 90, 120, 180, 240],
            labels: const ['1 د', '1.5 د', '2 د', '3 د', '4 د'],
            onChanged: (v) => audioProvider.setDiscussionTime(v),
          ),

          // وقت التصويت
          _buildTimeCard(
            icon: Icons.how_to_vote,
            title: 'وقت التصويت',
            selected: audioProvider.votingTime,
            options: const [30, 45, 60, 90, 120],
            labels: const ['30 ث', '45 ث', '1 د', '1.5 د', '2 د'],
            onChanged: (v) => audioProvider.setVotingTime(v),
          ),

          const SizedBox(height: 30),

          // ========== قواعد اللعبة ==========
          _buildSectionTitle('📋 قواعد اللعبة'),
          const SizedBox(height: 12),
          _buildRulesCard(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.goldAccent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bloodRed.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.goldAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.goldAccent,
            inactiveTrackColor: AppTheme.cardLight,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard({
    required IconData icon,
    required String title,
    required double value,
    required Function(double) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bloodRed.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.goldAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16))),
              Text('${(value * 100).round()}%', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            ],
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.goldAccent,
            inactiveColor: AppTheme.cardLight,
            min: 0.0,
            max: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard({
    required IconData icon,
    required String title,
    required int selected,
    required List<int> options,
    required List<String> labels,
    required Function(int) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bloodRed.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.goldAccent, size: 24),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(options.length, (index) {
              final isSelected = selected == options[index];
              return GestureDetector(
                onTap: () => onChanged(options[index]),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.bloodRed : AppTheme.cardLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppTheme.goldAccent : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
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
        border: Border.all(color: AppTheme.bloodRed.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildRuleItem('🎭', 'كل لاعب يحصل على دور سري (مافيا أو بريء)'),
          const SizedBox(height: 10),
          _buildRuleItem('🃏', 'يتم كشف دليل واحد في كل جولة'),
          const SizedBox(height: 10),
          _buildRuleItem('💬', 'ناقش الأدلة ودافع عن نفسك'),
          const SizedBox(height: 10),
          _buildRuleItem('🗳️', 'كل لاعب يصوت على حدة لإقصاء المشتبه بهم'),
          const SizedBox(height: 10),
          _buildRuleItem('🎯', 'الأبرياء يفوزون بالقضاء على كل المافيا'),
          const SizedBox(height: 10),
          _buildRuleItem('⚖️', 'عند تبقى لاعبين: هيئة المحلفين (اللاعبين الخارجين) تقرر'),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
}