import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/levels/level.dart';

class Wall extends SpriteComponent {
  final GameItem _item;
  Wall(this._item) {
    sprite = Sprite('wall-metal.png');
    angle = _item.type == GameItemType.VerticalWall ? pi : 0;
  }

  void resize(Size size) {
    final rect = rectFromItem(Config.tileSize, _item, 1.0);
    setByRect(rect);
  }
}
