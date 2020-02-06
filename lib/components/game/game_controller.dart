import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/static/component.dart';
import 'package:ufo_2d/types/interfaces.dart';

class GameController extends Controller<GameModel> {
  GameModel init(
          Size gameSize, PlayerModel player, List<StaticModel> staticModels) =>
      GameModel(
          rect: rectFromSize(0, 0, gameSize),
          player: player,
          statics: staticModels);

  GameModel resize(GameModel model, Size gameSize, Size tileSize) {
    final Rect x = model.rect;
    return model.copyWith(
      rect: rectFromSize(x.left, x.top, gameSize),
    );
  }

  GameModel update(GameModel model, double dt) {
    return model;
  }
}
