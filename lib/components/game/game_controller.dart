import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/controllers/collissions/player_collission_controller.dart';
import 'package:ufo_2d/controllers/collissions/player_pickup.dart';
import 'package:ufo_2d/controllers/collissions/player_wall.dart';
import 'package:ufo_2d/types/interfaces.dart';

class GameController extends Controller<GameModel> {
  final List<Updater> _updaters;
  GameController()
      : _updaters = [
          PlayerCollissionController(
            GameModel.getPlayer,
            GameModel.getWalls,
            GameModel.getPickups,
            const PlayerWallCollission(
              GameModel.updatePlayer,
              GameModel.updateStats,
            ),
            const PlayerPickupCollission(
              GameModel.updateStats,
              GameModel.updatePickup,
            ),
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
