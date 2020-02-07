import 'dart:ui';

import 'package:ufo_2d/components/player/player_controller.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/player/player_view.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/base.dart';
import 'package:ufo_2d/types/typedefs.dart';

class Player
    extends DynamicComponent<PlayerModel, PlayerController, PlayerView> {
  Player(
    GetModel<PlayerModel> getModel,
    SetModel<PlayerModel> setModel,
    GetTileSize getTileSize,
  ) : super(
          getModel: getModel,
          setModel: setModel,
          controller: PlayerController(),
          view: PlayerView(),
          getTileSize: getTileSize,
        );

  PlayerModel init(Size gameSize, GameItem item) {
    final tileSize = getTileSize(gameSize);
    return this.controller.init(gameSize, tileSize, item);
  }
}
