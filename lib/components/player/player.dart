import 'dart:ui';

import 'package:ufo_2d/components/player/player_controller.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/player/player_view.dart';
import 'package:ufo_2d/types/base.dart';
import 'package:ufo_2d/types/typedefs.dart';

class Player extends ComponentBase<PlayerModel, PlayerController, PlayerView> {
  Player(
    GetModel<PlayerModel> getModel,
    SetModel<PlayerModel> setModel,
  ) : super(getModel, setModel, PlayerController(), PlayerView());

  PlayerModel init(Size gameSize) {
    return this.controller.init(gameSize);
  }
}
