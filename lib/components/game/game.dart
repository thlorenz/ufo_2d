import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flutter/foundation.dart';
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
    Walls walls;
    Pickups pickups;
    Player player;

    if (GameModel.instance == null) {
      player = Player.fromItem(level.player);
      pickups = Pickups.fromItems(level.items);
      walls = Walls.fromItems(level.items);

      debugPrint('setting model');
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
    } else {
      player = Player(GameModel.instance.player);
      pickups = Pickups(GameModel.instance.pickups);
      walls = Walls(GameModel.instance.walls);
    }
    add(Background());
    walls.components.forEach(add);
    pickups.components.forEach(add);
    add(player.component);

    _controller = GameController();
  }

  GameModel get model => GameModel.instance;

  void update(double dt) {
    final nonzeroDt = dt == 0 ? 0.01 : dt;
    _cameraFollow(dt);
    super.update(nonzeroDt);
    _controller.update(nonzeroDt);
  }

  void resize(Size size) {
    debugPrint('before resize: ${GameModel.instance.player.rect}');
    super.resize(size);
    _controller.resize(size);

    final p = GameModel.instance.player.rect;
    debugPrint('resize: $p');
    camera = Position(p.left, p.top)
        .minus(Position(model.device.width / 2, model.device.height / 2));
  }

  void _cameraFollow(double dt) {
    final p = model.player.rect;
    final pos = Position(p.left, p.top)
        .minus(Position(model.device.width / 2, model.device.height / 2));
    final lerp = 2.5;
    final dx = (pos.x - camera.x) * dt * lerp;
    final dy = (pos.y - camera.y) * dt * lerp;
    camera = camera.add(Position(dx, dy));
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    GameGestures.instance.onPanUpdate(details);
  }

  void onPanEnd(DragEndDetails details) {
    GameGestures.instance.onPanEnd(details);
  }
}
