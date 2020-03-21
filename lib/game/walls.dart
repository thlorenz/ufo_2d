import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/types.dart';

class Walls {
  final List<TilePosition> _walls;
  final List<Rect> _rects;
  final Sprite _sprite;
  final List<List<bool>> _wallTiles;

  Walls(this._walls, this._wallTiles)
      : _sprite = Sprite('static/wall-metal.png'),
        _rects = List<Rect>() {
    _initRects();
  }

  void render(Canvas canvas) {
    for (final rect in _rects) {
      _sprite.renderRect(canvas, rect);
    }
  }

  bool wallAt(TilePosition tilePosition) {
    return _wallTiles[tilePosition.col][tilePosition.row];
  }

  _initRects() {
    _rects.clear();
    final w = GameProps.tileSize;
    final c = GameProps.tileCenter;
    for (int i = 0; i < _walls.length; i++) {
      final worldPos = WorldPosition.fromTilePosition(_walls[i]);
      final rect = Rect.fromLTWH(worldPos.x - c, worldPos.y - c, w, w);
      _rects.add(rect);
    }
  }
}
