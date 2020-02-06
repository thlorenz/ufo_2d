import 'dart:ui';

import 'package:flame/game.dart';
import 'package:ufo_2d/components/background/background.dart';
import 'package:ufo_2d/components/game/game_controller.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/player/player.dart';
import 'package:ufo_2d/components/player/player_model.dart';

void noop() {}

class Game extends BaseGame {
  final GameController _controller;
  Game() : _controller = GameController();

  GameModel get model => GameModel.instance;

  PlayerModel getPlayerModel() {
    return model.player;
  }

  void setPlayerModel(PlayerModel player) {
    GameModel.update(model.copyWith(player: player));
  }

  void init(Size gameSize) {
    final player = Player(getPlayerModel, setPlayerModel);
    final playerModel = player.init(gameSize);
    final gameModel = _controller.init(gameSize, playerModel);
    GameModel.init(gameModel);

    this.add(Background());
    this.add(player);
  }

  void update(double dt) {
    final nonzeroDt = dt == 0 ? 0.01 : dt;
    super.update(nonzeroDt);
    GameModel.update(_controller.update(model, nonzeroDt));
  }

  void resize(Size size) {
    super.resize(size);
    _controller.resize(model, size);
  }
}
