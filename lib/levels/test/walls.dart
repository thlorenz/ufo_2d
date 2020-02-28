import 'package:ufo_2d/levels/level.dart';

class LevelWalls {
  static GameLevel build() {
    return GameLevel('''
    |012345678901234567894567890123456789|
    (---------------------)
    (                     )
    (                     )
    (              p      )
    (                     )
    (                     )
    (                     )
    (                     )
    (                     )
    (---------------------)
    |012345678901234567890|
    ''');
  }
}
