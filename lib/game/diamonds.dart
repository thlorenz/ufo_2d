import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/types.dart';

class Diamonds {
  final List<TilePosition> _diamonds;
  final List<Rect> _rects;
  final Sprite _sprite;

  Diamonds(this._diamonds)
      : _sprite = Sprite('static/diamond.png'),
        _rects = List<Rect>() {
    _initRects();
  }

  void render(Canvas canvas) {
    for (final rect in _rects) {
      _sprite.renderRect(canvas, rect);
    }
  }

  _initRects() {
    _rects.clear();
    final w = GameProps.tileSize;
    final c = GameProps.tileCenter;
    for (int i = 0; i < _diamonds.length; i++) {
      final worldPos = WorldPosition.fromTilePosition(_diamonds[i]);
      final rect = Rect.fromLTWH(worldPos.x - c, worldPos.y - c, w, w);
      _rects.add(rect);
    }
  }
}
