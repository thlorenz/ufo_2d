import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/pickups/pickup.dart';
import 'package:ufo_2d/types.dart';

class Diamond extends Pickup {
  Diamond() : super(score: GameProps.scoreDiamond, type: PickupType.Diamond);
}

class Diamonds {
  final List<Rect> _rects;
  final Sprite _sprite;

  Diamonds(List<TilePosition> diamondTiles)
      : _sprite = Sprite('static/diamond.png'),
        _rects = List<Rect>() {
    _updateRects(diamondTiles);
  }

  void update(List<TilePosition> diamondTiles) {
    if (diamondTiles.length != _rects.length) _updateRects(diamondTiles);
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
