import 'dart:ui';

import 'package:flame/game.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/background.dart';
import 'package:ufo_2d/game/player.dart';
import 'package:ufo_2d/game/walls.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/game_model.dart';
import 'package:ufo_2d/types.dart';

class UfoGame extends Game {
  final GetModel<GameModel> getGame;
  final Tilemap tilemap;
  final Background _background;
  final Walls _walls;
  final Player _player;
  Size _size;

  UfoGame({this.getGame, this.tilemap, GameModel model})
      : _background = Background(tilemap, model.floorTiles),
        _walls = Walls(model.walls),
        _player = Player(GameModel.getPlayer);

  void update(double t) {}
  void render(Canvas canvas) {
    _withOriginLeftBottom(canvas, () {
      _renderCanvasFrame(canvas);
      _renderWorldFrame(canvas);
      _background.render(canvas);
      _walls.render(canvas);
      _player.render(canvas);
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
