import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/controllers/collissions/player-collission-controller.dart';
import 'package:ufo_2d/types/interfaces.dart';

class GameController extends Controller<GameModel> {
  final List<Updater> _updaters;
  GameController()
      : _updaters = [
          PlayerCollissionController(
            GameModel.getPlayer,
            GameModel.setPlayer,
            GameModel.getWalls,
          )
        ],
        super(() => GameModel.instance, GameModel.set);

  void resize(Size deviceSize) {
    updateModel((m) {
      final Rect x = m.rect;
      return m.copyWith(device: rectFromSize(x.left, x.top, deviceSize));
    });
  }

  void update(double dt) {
    _updaters.forEach((x) => x.update(dt));
  }
}
