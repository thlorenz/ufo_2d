import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/levels/level_01.dart';
import 'package:ufo_2d/levels/test/blackholes.dart';

class Levels {
  static GameLevel get level1 {
    return Level1.build();
  }

  static GameLevel get testBlackholes {
    return LevelBlackhole.build();
  }
}
