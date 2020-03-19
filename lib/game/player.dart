import 'dart:math';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/hit_tiles.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/types.dart';

class Player {
  final GetModel<PlayerModel> _getModel;
  final Sprite _playerSprite;
  Player(this._getModel) : _playerSprite = Sprite('ufo.png');

  void render(Canvas canvas, {Sprite rocketThrust}) {
    final model = _getModel();
    final wp = model.worldPosition;
    final width = GameProps.tileSize;
    final height = GameProps.tileSize;
    final angle = model.angle;

    if (GameProps.debugHitPoints) _renderHitPoints(canvas);

    canvas.save();
    canvas.translate(wp.x, wp.y);
    canvas.rotate(angle);

    _playerSprite.renderCentered(
      canvas,
      Position(0, 0),
      size: Position(width, height),
    );

    if (rocketThrust != null) _renderRocketFire(canvas, model, rocketThrust);

    canvas.restore();
  }

  void _renderHitPoints(Canvas canvas) {
    final wp = _getModel().worldPosition;
    final hit = getHitTiles(wp);

    final renderHit = (TilePosition tp) => canvas.drawCircle(
        WorldPosition.fromTilePosition(tp).toOffset(),
        2,
        GameProps.debugHitPointPaint);

    renderHit(wp.toTilePosition());
    renderHit(hit.topLeft);
    renderHit(hit.topRight);
    renderHit(hit.bottomRight);
    renderHit(hit.bottomLeft);
  }

  void _renderRocketFire(
    Canvas canvas,
    PlayerModel model,
    Sprite rocketFire,
  ) {
    final radius = GameProps.tileSize * 0.4;

    canvas.save();
    canvas.translate(-(radius * 1.6), 0);
    canvas.rotate(pi / 2);
    rocketFire.renderCentered(
      canvas,
      Position(0, 0),
      size: Position(radius, radius * 2),
    );
    canvas.restore();

    if (GameProps.debugThrust) _debugRenderRocketFire(radius, canvas);
  }

  void _debugRenderRocketFire(double radius, Canvas canvas) {
    final width = radius;
    final length = radius * 2;
    final p1 = Offset(-radius, -width / 2);
    final p2 = Offset(-radius, width / 2);
    final p3 = Offset(-radius - length, 0);
    canvas.drawLine(p1, p2, GameProps.debugThrustPaint);
    canvas.drawLine(p2, p3, GameProps.debugThrustPaint);
    canvas.drawLine(p3, p1, GameProps.debugThrustPaint);
  }
}
