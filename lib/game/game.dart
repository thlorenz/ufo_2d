import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/game_model.dart';
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
class Background extends SpriteComponent {
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
      final rect = Rect.fromLTWH(worldPos.x + c, worldPos.y + c, w, w);

      final sheetRow = i % 7;
      final sheetCol = (i ~/ nrows) % 7;
      final sprite = _spriteSheet.getSprite(sheetRow, sheetCol);
      final bs = BackgroundSprite(rect, sprite);
      _backgroundSprites.add(bs);
    }
  }
}

class UfoGame extends Game {
  final GetModel<GameModel> getGame;
  final Tilemap tilemap;
  final Background _background;
  Size _size;

  UfoGame({this.getGame, this.tilemap, GameModel model})
      : _background = Background(tilemap, model.floorTiles);

  void update(double t) {}
  void render(Canvas canvas) {
    _withOriginLeftBottom(canvas, () {
      _renderCanvasFrame(canvas);
      _renderWorldFrame(canvas);
      _background.render(canvas);
    });
  }

  void resize(Size size) {
    _size = size;
  }

  void _withOriginLeftBottom(Canvas canvas, void Function() render) {
    canvas.save();
    canvas.translate(0, _size.height);
    canvas.scale(1, -1);
    render();

    canvas.restore();
  }

  void _renderCanvasFrame(Canvas canvas) {
    final frame = Rect.fromLTWH(0, 0, _size.width, _size.height);
    canvas.drawRect(frame, GameProps.canvasFrame);
  }

  void _renderWorldFrame(Canvas canvas) {
    final w = tilemap.ncols * GameProps.tileSize;
    final h = tilemap.nrows * GameProps.tileSize;
    final frame = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(frame, GameProps.worldFrame);
  }

  String toString() {
    return '''
UfoGame 
$tilemap''';
  }
}
