import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/background.dart';
import 'package:ufo_2d/game/pickups/pickups.dart';
import 'package:ufo_2d/game/player.dart';
import 'package:ufo_2d/game/player_actions.dart';
import 'package:ufo_2d/game/player_movement.dart';
import 'package:ufo_2d/game/walls.dart';
import 'package:ufo_2d/inputs/gestures.dart';
import 'package:ufo_2d/inputs/keyboard.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/game_model.dart';
import 'package:ufo_2d/models/hud_model.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/sprites/dymamics.dart';
import 'package:ufo_2d/sprites/rocket-thrust.dart';
import 'package:ufo_2d/types.dart';

class UfoGame extends Game {
  final GetModel<GameModel> getGame;
  final GetModel<PlayerModel> getPlayer;
  final SetModel<PlayerModel> setPlayer;
  final GetModel<HudModel> getHud;
  final SetModel<HudModel> setHud;
  final GetModel<List<List<bool>>> getWallTiles;
  final GetModel<Iterable<TilePosition>> getDiamonds;
  final SetModel<List<TilePosition>> setDiamonds;
  final GetModel<Iterable<TilePosition>> getMedkits;
  final SetModel<List<TilePosition>> setMedkits;
  final Tilemap tilemap;
  final Background _background;
  final Walls _walls;
  final Player _player;
  final RocketThrust _rocketThrust;
  final Dynamics _dynamics;
  PlayerActions _playerActions;
  PlayerMovement _playerMovement;
  Pickups _pickups;

  Position _camera;

  Size _size;

  UfoGame({
    @required this.getGame,
    @required this.getPlayer,
    @required this.setPlayer,
    @required this.getHud,
    @required this.setHud,
    @required this.getWallTiles,
    @required this.getDiamonds,
    @required this.setDiamonds,
    @required this.getMedkits,
    @required this.setMedkits,
    @required this.tilemap,
    @required GameModel model,
  })  : _camera = Position.empty(),
        _background = Background(tilemap, model.floorTiles),
        _walls = Walls(model.walls, getWallTiles()),
        _player = Player(GameModel.getPlayer),
        _rocketThrust = RocketThrust.create(),
        _dynamics = Dynamics() {
    _playerMovement = PlayerMovement(walls: _walls);
    _playerActions = PlayerActions(walls: _walls);
    _pickups = Pickups(
      getDiamonds: getDiamonds,
      setDiamonds: setDiamonds,
      getMedkits: getMedkits,
      setMedkits: setMedkits,
      onScored: _onScored,
    );
  }

  void update(double dt) {
    PlayerModel player = getPlayer();
    HudModel hud = getHud();

    _playerActions.update(dt);

    final initialPlayerTile = player.tilePosition;
    for (final key in GameKeyboard.pressedKeys) {
      player = _processKey(player, key, dt);
    }
    player = _processGestures(
      player,
      GameGestures.instance.aggregatedGestures,
      dt,
    );
    final result = _playerMovement.realizeWallCollission(
      player,
      hud,
    );
    player = result.first;
    hud = result.second;

    if (!initialPlayerTile.isSameTileAs(player.tilePosition)) {
      hud = _pickups.checkForCollissionsAt(player.tilePosition, hud);
    }

    _rocketThrust.update(dt);
    _cameraFollow(player, dt);

    setPlayer(player);
    setHud(hud);

    _dynamics.update(dt);
  }

  void render(Canvas canvas) {
    _setOriginBottomLeft(canvas);

    canvas.translate(-_camera.x, -_camera.y);

    if (GameProps.debugCanvasFrame) {
      _renderCanvasFrame(canvas);
      _renderWorldFrame(canvas);
    }
    _background.render(canvas);
    _walls.render(canvas);

    _pickups.render(canvas);
    _dynamics.render(canvas);

    _player.render(
      canvas,
      rocketThrust: _rocketThrust.sprite,
    );
  }

  void resize(Size size) {
    _size = size;
  }

  void _setOriginBottomLeft(Canvas canvas) {
    canvas.translate(0, _size.height);
    canvas.scale(1, -1);
  }

  void _cameraFollow(PlayerModel player, double dt) {
    if (_size == null) return;
    final p = player.worldPosition;
    final pos =
        Position(p.x, p.y).minus(Position(_size.width / 2, _size.height / 2));
    final lerp = 2.5;
    final dx = (pos.x - _camera.x) * dt * lerp;
    final dy = (pos.y - _camera.y) * dt * lerp;
    _camera = _camera.add(Position(dx, dy));
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
        _rocketThrust.restart();
        return player.copyWith(
            velocity: PlayerMovement.directVelocity(
          player,
          dt * GameProps.keyboardPlayerSpeedFactor,
        ));
      case GameKey.Left:
        return player.copyWith(
            angle: player.angle + GameProps.keyboardPlayerRotationStep);
      case GameKey.Right:
        return player.copyWith(
            angle: player.angle - GameProps.keyboardPlayerRotationStep);
      case GameKey.Down:
        return player;
      case GameKey.Button1:
        _fireShot(player, GameProps.keyboardMinTimeBetweenShotsSec);
        return player;
      default:
        throw Exception('Unhandled key $key');
    }
  }

  PlayerModel _processGestures(
    PlayerModel player,
    AggregatedGestures gestures,
    double dt,
  ) {
    if (gestures.rotation != 0) {
      player = player.copyWith(angle: player.angle - gestures.rotation);
    }
    if (gestures.thrust != 0) {
      _rocketThrust.restart();
      player = player.copyWith(
          velocity: PlayerMovement.directVelocity(player, -gestures.thrust));
    }
    if (gestures.shot)
      _fireShot(player, GameProps.gestureMinTimeBetweenShotsSec);

    return player;
  }

  void _fireShot(PlayerModel player, double minTimeBetweenShots) {
    final bullet = _playerActions.fireShot(player, minTimeBetweenShots);
    if (bullet != null) _dynamics.add(bullet);
  }

  void _onScored(TilePosition tile, int score) {
    _dynamics.addScore(tile, score);
  }

  String toString() {
    return '''
UfoGame 
$tilemap''';
  }
}
