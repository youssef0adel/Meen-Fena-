import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/audio_constants.dart';

enum BackgroundTrack {
  mainMenu,
  gamePlay,
  voting,
  suspense,
  reveal,
  victory,
  defeat,
}

class AudioProvider extends ChangeNotifier {
  bool _musicEnabled = true;
  bool _soundEffectsEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 1.0;
  BackgroundTrack _currentTrack = BackgroundTrack.mainMenu;
  
  // Preferences keys
  static const _musicEnabledKey = 'music_enabled';
  static const _sfxEnabledKey = 'sfx_enabled';
  static const _musicVolumeKey = 'music_volume';
  static const _sfxVolumeKey = 'sfx_volume';

  bool get musicEnabled => _musicEnabled;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  BackgroundTrack get currentTrack => _currentTrack;

  AudioProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = prefs.getBool(_musicEnabledKey) ?? true;
    _soundEffectsEnabled = prefs.getBool(_sfxEnabledKey) ?? true;
    _musicVolume = prefs.getDouble(_musicVolumeKey) ?? 0.7;
    _sfxVolume = prefs.getDouble(_sfxVolumeKey) ?? 1.0;
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicEnabledKey, _musicEnabled);
    await prefs.setBool(_sfxEnabledKey, _soundEffectsEnabled);
    await prefs.setDouble(_musicVolumeKey, _musicVolume);
    await prefs.setDouble(_sfxVolumeKey, _sfxVolume);
  }

  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    _savePreferences();
    notifyListeners();
  }

  void toggleSoundEffects() {
    _soundEffectsEnabled = !_soundEffectsEnabled;
    _savePreferences();
    notifyListeners();
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    _savePreferences();
    notifyListeners();
  }

  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    _savePreferences();
    notifyListeners();
  }

  void playTrack(BackgroundTrack track) {
    _currentTrack = track;
    notifyListeners();
    // In a real implementation, this would trigger actual audio playback
    // using a package like audioplayers or just_audio
  }

  // Sound effect triggers (called from game actions)
  void playCardFlip() => _playSfx(AudioConstants.cardFlip);
  void playVoteCast() => _playSfx(AudioConstants.voteCast);
  void playElimination() => _playSfx(AudioConstants.elimination);
  void playRevealRole() => _playSfx(AudioConstants.revealRole);
  void playTimerWarning() => _playSfx(AudioConstants.timerWarning);
  void playVictory() => _playSfx(AudioConstants.victory);
  void playDefeat() => _playSfx(AudioConstants.defeat);

  void _playSfx(String soundName) {
    if (!_soundEffectsEnabled) return;
    // Play sound effect
    debugPrint('🔊 Playing SFX: $soundName');
  }
}