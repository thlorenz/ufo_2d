import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:ufo_2d/components/static/component.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/interfaces.dart';

class DiamondView implements View<StaticModel> {
  final Sprite sprite;
  DiamondView() : sprite = Sprite('diamond.png');

  void render(Canvas c, StaticModel model) {
    sprite.renderRect(c, model.rect);
  }
}

View<StaticModel> viewForStaticModel(StaticModel model) {
  switch (model.item.type) {
    case GameItemType.Player:
      throw Exception('player is a dynamic');
    case GameItemType.Diamond:
      return DiamondView();
    default:
      throw Exception('Unknown type: ${model.item.type}');
  }
}
