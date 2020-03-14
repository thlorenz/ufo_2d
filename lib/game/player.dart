import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/types.dart';

class HitTiles {
  final TilePosition topLeft;
  final TilePosition topRight;
  final TilePosition bottomRight;
  final TilePosition bottomLeft;

  HitTiles({
    @required this.topLeft,
    @required this.topRight,
    @required this.bottomRight,
    @required this.bottomLeft,
  });
}

class Player {
  final GetModel<PlayerModel> _getModel;
  final Sprite _sprite;
  final Anchor _anchor;
  Player(this._getModel)
      : _sprite = Sprite('ufo.png'),
        _anchor = Anchor.center;

  void render(Canvas canvas) {
    final model = _getModel();
    final wp = model.worldPosition;
    final width = GameProps.tileSize;
    final height = GameProps.tileSize;
    final angle = model.angle;

    if (GameProps.debugHitPoints) _renderHitPoints(canvas);

    _prepareCanvas(canvas, wp, angle, width, height);
    _sprite.render(canvas, width: width, height: height);
  }

  // @see flame PositionComponent
  void _prepareCanvas(
    Canvas canvas,
    WorldPosition wp,
    double angle,
    double width,
    double height,
  ) {
    canvas.translate(wp.x, wp.y);
    canvas.rotate(angle);
    final double dx = -_anchor.relativePosition.dx * width;
    final double dy = -_anchor.relativePosition.dy * height;
    canvas.translate(dx, dy);

    canvas.translate(width / 2, height / 2);
    canvas.scale(1.0, -1.0);
    canvas.translate(-width / 2, -height / 2);
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

  HitTiles getHitTiles(WorldPosition wp) {
    final radius = GameProps.playerHitSize / 2;
    final topLeft =
        WorldPosition(wp.x - radius, wp.y + radius).toTilePosition();
    final topRight =
        WorldPosition(wp.x + radius, wp.y + radius).toTilePosition();
    final bottomRight =
        WorldPosition(wp.x + radius, wp.y - radius).toTilePosition();
    final bottomLeft =
        WorldPosition(wp.x - radius, wp.y - radius).toTilePosition();
    return HitTiles(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft);
  }
}
