import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:ufo_2d/components/pickup/pickup_controller.dart';
import 'package:ufo_2d/levels/level.dart';

class Pickup extends SpriteComponent {
  final PickupController _controller;

  Pickup(this._controller, GameItem item) {
    sprite = item.type == GameItemType.Diamond
        ? Sprite('static/diamond.png')
        : Sprite('ufo.png');
  }

  void resize(Size size) {
    _controller.resize(size);
    setByRect(_controller.model.rect);
  }
}
