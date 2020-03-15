import 'package:flame/animation.dart';
import 'package:flame/spritesheet.dart';

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

class RocketFire {
  static Animation create() {
    return _spriteSheet.createAnimation(
      0,
      stepTime: 0.012,
      from: 0,
      to: _columns,
      loop: false,
    );
  }
}
