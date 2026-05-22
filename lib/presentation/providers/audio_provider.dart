import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProvider extends ChangeNotifier {
  bool _musicEnabled = true;
  bool _soundEffectsEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 1.0;
  
  // ✅ إضافة وقت المناقشة والتصويت
  int _discussionTime = 120;
  int _votingTime = 60;

  bool get musicEnabled => _musicEnabled;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  int get discussionTime => _discussionTime;
  int get votingTime => _votingTime;

  AudioProvider() { _loadPreferences(); }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = prefs.getBool('music_enabled') ?? true;
    _soundEffectsEnabled = prefs.getBool('sfx_enabled') ?? true;
    _musicVolume = prefs.getDouble('music_volume') ?? 0.7;
    _sfxVolume = prefs.getDouble('sfx_volume') ?? 1.0;
    _discussionTime = prefs.getInt('discussion_time') ?? 120;
    _votingTime = prefs.getInt('voting_time') ?? 60;
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', _musicEnabled);
    await prefs.setBool('sfx_enabled', _soundEffectsEnabled);
    await prefs.setDouble('music_volume', _musicVolume);
    await prefs.setDouble('sfx_volume', _sfxVolume);
    await prefs.setInt('discussion_time', _discussionTime);
    await prefs.setInt('voting_time', _votingTime);
  }

  void toggleMusic() { _musicEnabled = !_musicEnabled; _savePreferences(); notifyListeners(); }
  void toggleSoundEffects() { _soundEffectsEnabled = !_soundEffectsEnabled; _savePreferences(); notifyListeners(); }
  void setMusicVolume(double v) { _musicVolume = v.clamp(0.0, 1.0); _savePreferences(); notifyListeners(); }
  void setSfxVolume(double v) { _sfxVolume = v.clamp(0.0, 1.0); _savePreferences(); notifyListeners(); }
  
  // ✅ دوال الوقت
  void setDiscussionTime(int seconds) { 
    _discussionTime = seconds; 
    _savePreferences(); 
    notifyListeners(); 
  }
  
  void setVotingTime(int seconds) { 
    _votingTime = seconds; 
    _savePreferences(); 
    notifyListeners(); 
  }
}