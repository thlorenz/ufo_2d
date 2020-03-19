import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/pickups/pickup.dart';
import 'package:ufo_2d/types.dart';

class Medkit extends Pickup {
  Medkit() : super(health: GameProps.healthMedkit, type: PickupType.Medkit);
}

class Medkits {
  final List<Rect> _rects;
  final Sprite _sprite;

  Medkits(List<TilePosition> medkitTiles)
      : _sprite = Sprite('static/medkit.png'),
        _rects = List<Rect>() {
    _updateRects(medkitTiles);
  }

  void update(List<TilePosition> medkitTiles) {
    if (medkitTiles.length != _rects.length) _updateRects(medkitTiles);
  }

  void render(Canvas canvas) {
    for (final rect in _rects) {
      _sprite.renderRect(canvas, rect);
    }
  }

  _updateRects(List<TilePosition> medkits) {
    _rects.clear();
    final w = GameProps.tileSize;
    final c = GameProps.tileCenter;
    for (int i = 0; i < medkits.length; i++) {
      final worldPos = WorldPosition.fromTilePosition(medkits[i]);
      final rect = Rect.fromLTWH(worldPos.x - c, worldPos.y - c, w, w);
      _rects.add(rect);
    }
  }
}
