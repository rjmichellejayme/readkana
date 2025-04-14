import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/sound.dart';

class SoundService extends ChangeNotifier {
  Sound? _currentSound;
  bool _isPlaying = false;
  double _volume = 1.0;

  final List<Sound> availableSounds = [
    const Sound(
      name: 'Rain',
      displayName: 'Rainfall',
      assetPath: 'assets/sounds/rain.mp3',
    ),
    const Sound(
      name: 'Waves',
      displayName: 'Ocean Waves',
      assetPath: 'assets/sounds/waves.mp3',
    ),
    const Sound(
      name: 'Forest',
      displayName: 'Forest Ambience',
      assetPath: 'assets/sounds/forest.mp3',
    ),
    const Sound(
      name: 'Cafe',
      displayName: 'Cafe Atmosphere',
      assetPath: 'assets/sounds/cafe.mp3',
    ),
  ];

  Sound? get currentSound => _currentSound;
  bool get isPlaying => _isPlaying;
  double get volume => _volume;

  Future<void> playSound(Sound sound) async {
    if (_currentSound != sound) {
      await stopSound();
      _currentSound = sound;
    }
    _isPlaying = true;
    // TODO: Implement actual sound playback
    notifyListeners();
  }

  Future<void> stopSound() async {
    _isPlaying = false;
    // TODO: Implement actual sound stopping
    notifyListeners();
  }

  Future<void> pauseSound() async {
    if (_isPlaying) {
      _isPlaying = false;
      // TODO: Implement actual sound pausing
      notifyListeners();
    }
  }

  Future<void> resumeSound() async {
    if (_currentSound != null && !_isPlaying) {
      _isPlaying = true;
      // TODO: Implement actual sound resuming
      notifyListeners();
    }
  }

  void setVolume(double value) {
    if (value >= 0 && value <= 1) {
      _volume = value;
      // TODO: Implement actual volume change
      notifyListeners();
    }
  }
}
