import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/static/component.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/interfaces.dart';

class GameController extends Controller<GameModel> {
  GameModel init(
    GameLevel level,
    Size deviceSize,
    Size tileSize,
    PlayerModel player,
    List<StaticModel> staticModels,
  ) =>
      GameModel(
          device: rectFromSize(0, 0, deviceSize),
          level: level,
          rect: rectFromSize(
              0,
              0,
              Size(
                level.ncols * tileSize.width,
                level.nrows * tileSize.height,
              )),
          player: player,
          statics: staticModels);

  GameModel resize(GameModel model, Size deviceSize) {
    final Rect x = model.rect;
    return model.copyWith(
      device: rectFromSize(x.left, x.top, deviceSize),
    );
  }

  GameModel update(GameModel model, double dt) {
    return model;
  }
}
