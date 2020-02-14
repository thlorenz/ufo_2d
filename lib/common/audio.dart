import 'dart:io';

import 'package:flame/flame.dart';
import 'package:ufo_2d/common/config.dart';

class Audio {
  final bool _platformSupportsAudio;
  Audio._() : _platformSupportsAudio = !Platform.isMacOS;
  bool get shouldPlay {
    return _platformSupportsAudio && Config.audioOn;
  }

  void loadAll() {
    if (!shouldPlay) return;
    Flame.audio.loadAll(['thrust.mp3']);
  }

  void play(String file) {
    if (shouldPlay) Flame.audio.play(file);
  }

  static Audio _instance = Audio._();
  static Audio get instance {
    return _instance;
  }
}
