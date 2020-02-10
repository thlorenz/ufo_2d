import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:ufo_2d/components/wall/wall_controller.dart';
import 'package:ufo_2d/levels/level.dart';

class Wall extends SpriteComponent {
  final WallController _controller;

  Wall(this._controller, GameItem item) {
    sprite = Sprite('static/wall-rock.png');
    angle = item.type == GameItemType.VerticalWall ? pi : 0;
  }

  void resize(Size size) {
    _controller.resize(size);
    setByRect(_controller.model.rect);
  }
}
