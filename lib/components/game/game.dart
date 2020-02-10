import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/background/background.dart';
import 'package:ufo_2d/components/game/game_controller.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/pickup/pickups.dart';
import 'package:ufo_2d/components/player/player.dart';
import 'package:ufo_2d/components/wall/walls.dart';
import 'package:ufo_2d/inputs/gestures.dart';
import 'package:ufo_2d/levels/level.dart';

void noop() {}

class Game extends BaseGame with PanDetector {
  GameController _controller;

  Game(GameLevel level, Size deviceSize) {
    final player = Player(level.player);
    final pickups = Pickups(level.items);
    final walls = Walls(level.items);

    GameModel.set(
      GameModel(
        device: rectFromSize(0, 0, deviceSize),
        level: level,
        rect: rectFromSize(
            0,
            0,
            Size(
              level.ncols * Config.tileSize.width,
              level.nrows * Config.tileSize.height,
            )),
        player: player.model,
        pickups: pickups.models,
        walls: walls.models,
      ),
    );

    add(Background());
    walls.components.forEach(add);
    pickups.components.forEach(add);
    add(player.component);

    final p = player.model.rect;
    this.camera =
        Position(p.left, p.top).minus(Position(deviceSize.width / 2, 0));

    _controller = GameController();
  }

  GameModel get model => GameModel.instance;

  void update(double dt) {
    final nonzeroDt = dt == 0 ? 0.01 : dt;
    final p = model.player.rect;
    this.camera = Position(p.left, p.top)
        .minus(Position(model.device.width / 2, model.device.height / 2));
    super.update(nonzeroDt);
    _controller.update(nonzeroDt);
  }

  void resize(Size size) {
    super.resize(size);
    _controller.resize(size);
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    GameGestures.instance.onPanUpdate(details);
  }

  void onPanEnd(DragEndDetails details) {
    GameGestures.instance.onPanEnd(details);
  }
}
