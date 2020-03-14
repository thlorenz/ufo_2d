import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/background.dart';
import 'package:ufo_2d/game/diamonds.dart';
import 'package:ufo_2d/game/player.dart';
import 'package:ufo_2d/game/walls.dart';
import 'package:ufo_2d/inputs/keyboard.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/game_model.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/types.dart';

class UfoGame extends Game {
  final GetModel<GameModel> getGame;
  final GetModel<PlayerModel> getPlayer;
  final SetModel<PlayerModel> setPlayer;
  final GetModel<List<List<bool>>> getWallTiles;
  final Tilemap tilemap;
  final Background _background;
  final Walls _walls;
  final Diamonds _diamonds;
  final Player _player;
  Size _size;

  final _keyboard = GameKeyboard.instance;

  UfoGame({
    @required this.getGame,
    @required this.getPlayer,
    @required this.setPlayer,
    @required this.getWallTiles,
    @required this.tilemap,
    @required GameModel model,
  })  : _background = Background(tilemap, model.floorTiles),
        _walls = Walls(model.walls),
        _diamonds = Diamonds(model.diamonds),
        _player = Player(GameModel.getPlayer);

  void update(double dt) {
    PlayerModel player = getPlayer();
    for (final key in _keyboard.pressedKeys) {
      player = _processKey(player, key, dt);
    }
    player = _updatePlayerMovement(player);
    setPlayer(player);
  }

  void render(Canvas canvas) {
    _withOriginLeftBottom(canvas, () {
      _renderCanvasFrame(canvas);
      _renderWorldFrame(canvas);
      _background.render(canvas);
      _walls.render(canvas);
      _diamonds.render(canvas);
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

  PlayerModel _processKey(PlayerModel player, GameKey key, double dt) {
    switch (key) {
      case GameKey.Up:
        return _increasePlayerVelocity(player, dt);
      case GameKey.Left:
        return player.copyWith(
            angle: player.angle + GameProps.keyboardPlayerRotationStep);
      case GameKey.Right:
        return player.copyWith(
            angle: player.angle - GameProps.keyboardPlayerRotationStep);
      case GameKey.Down:
        return player;
      default:
        throw Exception('Unhandled key $key');
    }
  }

  PlayerModel _increasePlayerVelocity(PlayerModel player, double dt) {
    final velocity = Player.increaseVelocity(
      player,
      dt * GameProps.keyboardPlayerSpeedFactor,
    );
    return player.copyWith(velocity: velocity);
  }

  WorldPosition _nextPlayerPosition(PlayerModel player) {
    return WorldPosition(
      player.worldPosition.x + player.velocity.x,
      player.worldPosition.y + player.velocity.y,
    );
  }

  PlayerModel _updatePlayerMovement(PlayerModel player) {
    final next = _nextPlayerPosition(player);
    final hit = Player.getHitTiles(player.worldPosition);
    final nextHit = Player.getHitTiles(next);

    final reflectX =
        () => player.copyWith(velocity: player.velocity.scale(-1, 1));
    final reflectY =
        () => player.copyWith(velocity: player.velocity.scale(1, -1));
    final handleHit = (TilePosition edge, TilePosition nextEdge) =>
        edge.col == nextEdge.col ? reflectY() : reflectX();

    if (_wallAt(nextHit.bottomRight)) {
      if (_wallAt(nextHit.bottomLeft)) return reflectY();
      if (_wallAt(nextHit.topRight)) return reflectX();
      return handleHit(hit.bottomRight, nextHit.bottomRight);
    }
    if (_wallAt(nextHit.topRight)) {
      if (_wallAt(nextHit.topLeft)) return reflectY();
      if (_wallAt(nextHit.bottomRight)) return reflectX();
      return handleHit(hit.topRight, nextHit.topRight);
    }
    if (_wallAt(nextHit.bottomLeft)) {
      if (_wallAt(nextHit.topLeft)) return reflectX();
      return handleHit(hit.bottomLeft, nextHit.bottomLeft);
    }
    if (_wallAt(nextHit.topLeft)) {
      return handleHit(hit.topLeft, nextHit.topLeft);
    }

    return player.copyWith(tilePosition: next.toTilePosition());
  }

  bool _wallAt(TilePosition tilePosition) {
    final tiles = getWallTiles();
    return tiles[tilePosition.col][tilePosition.row];
  }

  String toString() {
    return '''
UfoGame 
$tilemap''';
  }
}
