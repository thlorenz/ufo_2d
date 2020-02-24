import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';
import 'package:ufo_2d/common/audio.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/background/background.dart';
import 'package:ufo_2d/components/blackhole/blackholes.dart';
import 'package:ufo_2d/components/game/game_controller.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/pickup/pickups.dart';
import 'package:ufo_2d/components/player/player.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/sprites/rocket-fire.dart';
import 'package:ufo_2d/components/stats/stats_model.dart';
import 'package:ufo_2d/components/wall/walls.dart';
import 'package:ufo_2d/inputs/gestures.dart';
import 'package:ufo_2d/levels/level.dart';

void noop() {}

class Game extends BaseGame with PanDetector {
  GameController _controller;
  RocketFire rocketFire;

  Game(GameLevel level, Size deviceSize) {
    Blackholes blackholes;
    Walls walls;
    Pickups pickups;
    Player player;
    StatsModel statsModel;

    if (GameModel.instance == null) {
      player = Player.fromItem(level.player);
      pickups = Pickups.fromItems(level.items);
      walls = Walls.fromItems(level.items);
      blackholes = Blackholes.fromItems(level.items);
      statsModel = StatsModel(health: Config.totalHealth, score: 0);

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
          blackholes: blackholes.models,
          stats: statsModel,
        ),
      );
    } else {
      player = Player(GameModel.instance.player);
      pickups = Pickups(GameModel.instance.pickups);
      walls = Walls(GameModel.instance.walls);
      blackholes = Blackholes(GameModel.instance.blackholes);
    }

    rocketFire = RocketFire(GameModel.getPlayer);

    add(Background());
    walls.components.forEach(add);
    blackholes.components.forEach(add);
    pickups.components.forEach(add);
    add(player.component);

    _controller = GameController();
  }

  GameModel get model => GameModel.instance;

  void update(double dt) {
    final nonzeroDt = dt == 0 ? 0.01 : dt;
    _cameraFollow(dt);
    _processPlayerEvents(model.player);
    super.update(nonzeroDt);
    _controller.update(nonzeroDt);
  }

  void _processPlayerEvents(PlayerModel m) {
    if (m.events.isEmpty) return;
    final event = m.events.first;
    m.events.removeAt(0);
    switch (event) {
      case PlayerEvent.speedChanged:
        if (components
            .where((x) => x.runtimeType == RocketFireComponent)
            .isEmpty) {
          add(rocketFire.component);
          Audio.instance.play('thrust.mp3');
        }
        break;
    }
  }

  void resize(Size size) {
    super.resize(size);
    _controller.resize(size);

    final p = GameModel.instance.player.rect;
    camera = _lastCamera ??
        Position(p.left, p.top)
            .minus(Position(model.device.width / 2, model.device.height / 2));
  }

  void _cameraFollow(double dt) {
    final p = model.player.rect;
    final pos = Position(p.left, p.top)
        .minus(Position(model.device.width / 2, model.device.height / 2));
    final lerp = 2.5;
    final dx = (pos.x - camera.x) * dt * lerp;
    final dy = (pos.y - camera.y) * dt * lerp;
    _lastCamera = camera = camera.add(Position(dx, dy));
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    GameGestures.instance.onPanUpdate(details);
  }

  void onPanEnd(DragEndDetails details) {
    GameGestures.instance.onPanEnd(details);
  }

  static Position _lastCamera;
}
