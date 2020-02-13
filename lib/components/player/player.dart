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
    c.save();
    super.render(c);
    c.restore();
    if (Config.debugRenderPlayer) {
      c.drawRect(_controller.model.rect, Config.debugRectPaint);
      c.drawRect(_controller.model.hit, Config.debugHitPaint);
      c.drawCircle(_controller.model.hit.center, 5.0, Config.debugCenterPaint);
    }
  }
}

class Player {
  final PlayerComponent component;
  final PlayerModel model;

  Player(this.model)
      : component = PlayerComponent(
          PlayerController(
            getModel: GameModel.getPlayer,
            setModel: GameModel.setPlayer,
          ),
        );

  factory Player.fromItem(GameItem item) {
    final rect = rectFromItem(
      Config.tileSize,
      item,
      Config.playerScaleFactor,
    );
    final hit = PlayerController.hitFrom(rect, Config.playerHitRatio);
    return Player(
      PlayerModel(
        rect: rect,
        hit: hit,
        speed: Offset(0, 0),
        item: item,
        angle: 0.0,
        events: List(),
      ),
    );
  }
}
