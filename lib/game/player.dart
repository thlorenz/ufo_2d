import 'dart:ui';

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
  Player(this._getModel) : _sprite = Sprite('ufo.png');

  void render(Canvas canvas) {
    final wp = _getModel().worldPosition;
    final w = GameProps.tileSize;
    final c = GameProps.tileCenter;
    final rect = Rect.fromLTWH(wp.x - c, wp.y - c, w, w);
    _sprite.renderRect(canvas, rect);

    if (GameProps.debugHitPoints) _renderHitPoints(canvas);
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
