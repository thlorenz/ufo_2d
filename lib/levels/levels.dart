import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/levels/level_01.dart';
import 'package:ufo_2d/levels/test/blackholes.dart';
import 'package:ufo_2d/levels/test/walls.dart';

class Levels {
  static GameLevel get level1 {
    return Level1.build();
  }

  static GameLevel get testBlackholes {
    return LevelBlackhole.build();
  }

  static GameLevel get testWalls {
    return LevelWalls.build();
  }
}
