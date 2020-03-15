import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/types.dart';

class Pickup {
  final int score;
  final double health;
  Pickup({this.score = 0, this.health = 0});
}

class Diamond extends Pickup {
  Diamond() : super(score: GameProps.scoreDiamond);
}

class Diamonds {
  final GetModel<Iterable<TilePosition>> getDiamonds;
  final List<Rect> _rects;
  final Sprite _sprite;

  Diamonds(this.getDiamonds)
      : _sprite = Sprite('static/diamond.png'),
        _rects = List<Rect>() {
    _updateRects(getDiamonds());
  }

  void update() {
    final diamonds = getDiamonds();
    if (diamonds.length != _rects.length) _updateRects(diamonds);
  }

  void render(Canvas canvas) {
    for (final rect in _rects) {
      _sprite.renderRect(canvas, rect);
    }
  }

  _updateRects(List<TilePosition> diamonds) {
    _rects.clear();
    final w = GameProps.tileSize;
    final c = GameProps.tileCenter;
    for (int i = 0; i < diamonds.length; i++) {
      final worldPos = WorldPosition.fromTilePosition(diamonds[i]);
      final rect = Rect.fromLTWH(worldPos.x - c, worldPos.y - c, w, w);
      _rects.add(rect);
    }
  }
}
