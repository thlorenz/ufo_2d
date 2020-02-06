import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/types/interfaces.dart';

class PlayerView implements View<PlayerModel> {
  final Sprite ufoSprite;
  PlayerView() : ufoSprite = Sprite('ufo.png');

  void render(Canvas c, PlayerModel model) {
    ufoSprite.renderRect(c, model.rect);
  }
}
