import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:ufo_2d/components/wall/wall_controller.dart';

class Wall extends SpriteComponent {
  final WallController _controller;

  Wall(this._controller) {
    sprite = Sprite('static/wall-metal.png');
  }

  void resize(Size size) {
    _controller.resize(size);
    setByRect(_controller.model.rect);
  }
}
