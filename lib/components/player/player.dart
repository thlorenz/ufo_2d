import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:ufo_2d/components/player/player_controller.dart';

class Player extends SpriteComponent {
  final PlayerController _controller;

  Player(this._controller) {
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
}
