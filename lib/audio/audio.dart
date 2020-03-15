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

  Future<AudioPlayer> player(String file, {double volume = 1.0}) async {
    final player = await play(file, volume: 0.0);
    player.stop();
    player.setVolume(volume);
    return player;
  }

  static Audio _instance = Audio._();
  static Audio get instance {
    return _instance;
  }
}
