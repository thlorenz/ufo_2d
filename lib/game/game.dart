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
    player = _updatePlayerPosition(player);
    player = _updatePlayerPosition(player);
    setPlayer(player);
    debugPrint('player: $player');
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
        return player.copyWith(
            velocity: player.velocity
                .translate(0, dt * GameProps.keyboardPlayerSpeedFactor));
      case GameKey.Down:
        return player.copyWith(
            velocity: player.velocity
                .translate(0, dt * (-GameProps.keyboardPlayerSpeedFactor)));
      case GameKey.Left:
        return player.copyWith(
            velocity: player.velocity
                .translate(dt * (-GameProps.keyboardPlayerSpeedFactor), 0));
      case GameKey.Right:
        return player.copyWith(
            velocity: player.velocity
                .translate(dt * GameProps.keyboardPlayerSpeedFactor, 0));
      default:
        throw Exception('Unhandled key $key');
    }
  }

  PlayerModel _updatePlayerPosition(PlayerModel player) {
    final worldPos = WorldPosition(
      player.worldPosition.x + player.velocity.x,
      player.worldPosition.y + player.velocity.y,
    );
    return player.copyWith(tilePosition: worldPos.toTilePosition());
  }

  String toString() {
    return '''
UfoGame 
$tilemap''';
  }
}
