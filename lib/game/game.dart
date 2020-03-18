import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/background.dart';
import 'package:ufo_2d/game/diamonds.dart';
import 'package:ufo_2d/game/player.dart';
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
  final Tilemap tilemap;
  final Background _background;
  final Walls _walls;
  final Diamonds _diamonds;
  final Player _player;
  final RocketThrust _rocketThrust;
  final Dynamics _dynamics;

  Position _camera;

  Size _size;

  final _keyboard = GameKeyboard.instance;

  UfoGame({
    @required this.getGame,
    @required this.getPlayer,
    @required this.setPlayer,
    @required this.getHud,
    @required this.setHud,
    @required this.getWallTiles,
    @required this.getDiamonds,
    @required this.setDiamonds,
    @required this.tilemap,
    @required GameModel model,
  })  : _camera = Position.empty(),
        _background = Background(tilemap, model.floorTiles),
        _walls = Walls(model.walls),
        _diamonds = Diamonds(getDiamonds()),
        _player = Player(GameModel.getPlayer),
        this._rocketThrust = RocketThrust.create(),
        _dynamics = Dynamics();

  void update(double dt) {
    PlayerModel player = getPlayer();
    HudModel hud = getHud();

    final initialPlayerTile = player.tilePosition;
    for (final key in _keyboard.pressedKeys) {
      player = _processKey(player, key, dt);
    }
    player = _processGestures(
      player,
      GameGestures.instance.aggregatedGestures,
      dt,
    );
    final result = _updatePlayerMovement(player, hud);
    player = result.first;
    hud = result.second;

    if (!initialPlayerTile.isSameTileAs(player.tilePosition)) {
      final diamondTiles = getDiamonds();
      final pickup = _pickupCollide(
        player.tilePosition,
        diamonds: diamondTiles,
      );
      if (pickup?.type == PickupType.Diamond) {
        setDiamonds(
          diamondTiles
              .where((x) => !x.isSameTileAs(player.tilePosition))
              .toList(),
        );
        _diamonds.update(getDiamonds());
      }
      if (pickup != null && pickup.hasScore) {
        _dynamics.addScore(player.tilePosition, pickup.score);
        hud = hud.copyWith(score: hud.score + pickup.score);
      }
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
    _diamonds.render(canvas);
    _player.render(
      canvas,
      rocketThrust: _rocketThrust.sprite,
    );
    _dynamics.render(canvas);
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
          velocity: Player.increaseVelocity(player, -gestures.thrust));
    }

    return player;
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

  Tuple<PlayerModel, HudModel> _updatePlayerMovement(
    PlayerModel player,
    HudModel hud,
  ) {
    final next = _nextPlayerPosition(player);
    final hit = Player.getHitTiles(player.worldPosition);
    final nextHit = Player.getHitTiles(next);

    final hitOnAxisX = () {
      double healthToll =
          player.velocity.x.abs() * GameProps.playerHitsWallHealthFactor;
      return Tuple(
          player.copyWith(
              velocity: player.velocity.scale(
            -GameProps.playerHitsWallSlowdown,
            GameProps.playerHitsWallSlowdown,
          )),
          hud.copyWith(health: hud.health - healthToll));
    };
    final hitOnAxisY = () {
      double healthToll =
          player.velocity.y.abs() * GameProps.playerHitsWallHealthFactor;
      return Tuple(
          player.copyWith(
              velocity: player.velocity.scale(
            GameProps.playerHitsWallSlowdown,
            -GameProps.playerHitsWallSlowdown,
          )),
          hud.copyWith(
            health: hud.health - healthToll,
          ));
    };
    final handleHit = (TilePosition edge, TilePosition nextEdge) =>
        edge.col == nextEdge.col ? hitOnAxisY() : hitOnAxisX();

    if (_wallAt(nextHit.bottomRight)) {
      if (_wallAt(nextHit.bottomLeft)) return hitOnAxisY();
      if (_wallAt(nextHit.topRight)) return hitOnAxisX();
      return handleHit(hit.bottomRight, nextHit.bottomRight);
    }
    if (_wallAt(nextHit.topRight)) {
      if (_wallAt(nextHit.topLeft)) return hitOnAxisY();
      if (_wallAt(nextHit.bottomRight)) return hitOnAxisX();
      return handleHit(hit.topRight, nextHit.topRight);
    }
    if (_wallAt(nextHit.bottomLeft)) {
      if (_wallAt(nextHit.topLeft)) return hitOnAxisX();
      return handleHit(hit.bottomLeft, nextHit.bottomLeft);
    }
    if (_wallAt(nextHit.topLeft)) {
      return handleHit(hit.topLeft, nextHit.topLeft);
    }

    return Tuple(player.copyWith(tilePosition: next.toTilePosition()), hud);
  }

  bool _wallAt(TilePosition tilePosition) {
    final tiles = getWallTiles();
    return tiles[tilePosition.col][tilePosition.row];
  }

  Pickup _pickupCollide(
    TilePosition tilePosition, {
    @required List<TilePosition> diamonds,
  }) {
    TilePosition tile;
    Pickup pickup;
    for (final d in diamonds) {
      if (d.isSameTileAs(tilePosition)) {
        tile = d;
        pickup = Diamond();
        break;
      }
    }
    if (tile == null) return null;
    return pickup;
  }

  String toString() {
    return '''
UfoGame 
$tilemap''';
  }
}
