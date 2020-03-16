import 'package:audioplayers/audioplayers.dart';
import 'package:flame/animation.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/audio/audio.dart';

const _columns = 50;
const int _width = 7700 ~/ _columns;
const _height = 442;

final _spriteSheet = SpriteSheet(
  imageName: 'sprites/rocket-fire.png',
  textureWidth: _width,
  textureHeight: _height,
  columns: _columns,
  rows: 1,
);

class RocketThrust {
  final Animation _animation;
  AudioPlayer _audio;
  bool _active;

  RocketThrust._(this._animation) : _active = false;

  Sprite get sprite => _active ? _animation.getSprite() : null;

  void update(double dt) {
    if (!_active) return;
    _animation.update(dt);
    _active = !_animation.done();
  }

  Future<void> restart() async {
    _animation.reset();
    _active = true;

    if (!GameProps.audioOn) return;
    if (_audio == null) _audio = await Audio.instance.play('thrust.mp3');
    _audio
      ..seek(Duration())
      ..resume();
  }

  static RocketThrust create() {
    final animation = _spriteSheet.createAnimation(
      0,
      stepTime: 0.012,
      from: 0,
      to: _columns,
      loop: false,
    );
    return RocketThrust._(animation);
  }
}
