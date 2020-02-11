import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/player/player_controller.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/levels/level.dart';

class PlayerComponent extends SpriteComponent {
  final PlayerController _controller;

  PlayerComponent(this._controller) {
    sprite = Sprite('ufo.png');
    anchor = Anchor.center;
  }

  void resize(Size size) {
    _controller.resize(size);
    setByRect(_controller.model.rect);
  }

  void update(double dt) {
    _controller.update(dt);
    angle = _controller.model.angle;
    setByRect(_controller.model.rect);
  }

  void render(Canvas c) {
    if (Config.debugRenderPlayer) {
      c.drawRect(_controller.model.rect, Config.debugRectPaint);
      c.drawRect(_controller.model.hit, Config.debugHitPaint);
    }
    super.render(c);
  }
}

class Player {
  PlayerComponent component;
  PlayerModel model;

  Player(GameItem item) {
    final rect = rectFromItem(
      Config.tileSize,
      item,
      Config.playerScaleFactor,
    );
    final hit = PlayerController.hitFrom(rect, Config.playerHitRatio);
    model = PlayerModel(
      rect: rect,
      hit: hit,
      speed: Offset(0, 0),
      item: item,
      angle: 0.0,
    );

    final playerController = PlayerController(
      getModel: GameModel.getPlayer,
      setModel: GameModel.setPlayer,
    );

    component = PlayerComponent(playerController);
  }
}
