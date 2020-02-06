import 'dart:ui';

import 'package:flame/sprite.dart';

class BackgroundView {
  Sprite bgSprite;

  BackgroundView() {
    bgSprite = Sprite('background.png');
  }

  void render(Canvas c, Rect rect) {
    bgSprite.renderRect(c, rect);
  }
}
