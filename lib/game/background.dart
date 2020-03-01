import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/types.dart';

class BackgroundSprite {
  final Rect rect;
  final Sprite sprite;

  BackgroundSprite(this.rect, this.sprite);

  static const imageName = 'bg/floor-8x8.png';
  static const rows = 8;
  static const columns = 8;
  static const textureHeight = 128;
  static const textureWidth = 128;
}

// The background nor walls change even though other entities
// on the tilemap will.
class Background {
  static const imageName = 'bg/floor-8x8.png';
  static const rows = 8;
  static const columns = 8;
  static const textureHeight = 128;
  static const textureWidth = 128;

  final Tilemap _tilemap;
  final List<TilePosition> _floorTiles;
  List<BackgroundSprite> _backgroundSprites;
  SpriteSheet _spriteSheet;

  Background(this._tilemap, this._floorTiles)
      : _backgroundSprites = List<BackgroundSprite>() {
    _spriteSheet = SpriteSheet(
      imageName: imageName,
      rows: rows,
      columns: columns,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    );
    _initSprites();
  }

  void render(Canvas canvas) {
    for (final bs in _backgroundSprites) {
      bs.sprite.renderRect(canvas, bs.rect);
    }
  }

  void _initSprites() {
    _backgroundSprites.clear();

    final w = GameProps.tileSize;
    final c = GameProps.tileCenter;
    final nrows = _tilemap.nrows;
    for (int i = 0; i < _floorTiles.length; i++) {
      final ft = _floorTiles[i];

      final worldPos = WorldPosition.fromTilePosition(ft);
      final rect = Rect.fromLTWH(worldPos.x - c, worldPos.y - c, w, w);

      final sheetRow = i % 7;
      final sheetCol = (i ~/ nrows) % 7;
      final sprite = _spriteSheet.getSprite(sheetRow, sheetCol);
      final bs = BackgroundSprite(rect, sprite);
      _backgroundSprites.add(bs);
    }
  }
}
