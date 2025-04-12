import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../utils/preferences_utils.dart';

class SoundService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 0.5;
  String? _currentSound;
  final List<String> _availableSounds = [
    'rain',
    'waves',
    'forest',
    'cafe',
    'white_noise',
  ];

  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  String? get currentSound => _currentSound;
  List<String> get availableSounds => _availableSounds;

  SoundService() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _volume = await PreferencesUtils.getSoundVolume();
    _currentSound = await PreferencesUtils.getCurrentSound();
    notifyListeners();
  }

  Future<void> playSound(String soundName) async {
    if (!_availableSounds.contains(soundName)) return;

    try {
      await _player.setAsset('assets/sounds/$soundName.mp3');
      await _player.setVolume(_volume);
      await _player.setLoopMode(LoopMode.one);
      await _player.play();

      _isPlaying = true;
      _currentSound = soundName;
      await PreferencesUtils.setCurrentSound(soundName);
      notifyListeners();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> stopSound() async {
    try {
      await _player.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
    await PreferencesUtils.setSoundVolume(_volume);
    notifyListeners();
  }

  Future<void> pauseSound() async {
    try {
      await _player.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      print('Error pausing sound: $e');
    }
  }

  Future<void> resumeSound() async {
    try {
      await _player.play();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print('Error resuming sound: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
