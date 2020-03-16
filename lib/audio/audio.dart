import 'package:audioplayers/audioplayers.dart';
import 'package:flame/flame.dart';

class Audio {
  Audio._();

  void loadAll() {
    Flame.audio.loadAll(['thrust.mp3']);
  }

  Future<AudioPlayer> play(String file, {double volume}) {
    return Flame.audio.play(file, volume: volume);
  }

  static Audio _instance = Audio._();
  static Audio get instance {
    return _instance;
  }
}
