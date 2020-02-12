import 'dart:ui';

import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

enum CollissionEdge {
  Top,
  Left,
  Right,
  Bottom,
}

CollissionEdge previousCollissionEdge;

class PlayerCollissionController extends Updater {
  final GetModel<PlayerModel> _getPlayerModel;
  final UpdateModel<PlayerModel> _updatePlayerModel;
  final GetModels<WallModel> _getWallModels;

  PlayerCollissionController(
    this._getPlayerModel,
    this._updatePlayerModel,
    this._getWallModels,
  );

  void update(double dt) {
    final walls = this._getWallModels();
    final player = this._getPlayerModel();
    final p = player.hit;
    final wallRects = walls.map((x) => x.rect);

    final collissionEdge = _getCollissionEdge(wallRects, p, player.speed, dt);
    if (collissionEdge == null) return;
    _updatePlayerModel((m) {
      Offset s = m.speed;
      Rect r = m.rect;
      if (collissionEdge == CollissionEdge.Top ||
          collissionEdge == CollissionEdge.Bottom) {
        s = Offset(
          s.dx * Config.playerHitWallSlowdown,
          -(s.dy * Config.playerHitWallSlowdown),
        );
        r = r.translate(s.dx * dt, s.dy * dt);
      }
      if (collissionEdge == CollissionEdge.Left ||
          collissionEdge == CollissionEdge.Right) {
        s = Offset(
          -(s.dx * Config.playerHitWallSlowdown),
          s.dy * Config.playerHitWallSlowdown,
        );
        r = r.translate(s.dx * dt, s.dy * dt);
      }
      return m.copyWith(speed: s, rect: r);
    });

    if (collissionEdge != previousCollissionEdge) {
      previousCollissionEdge = collissionEdge;
    }
  }

  CollissionEdge _getCollissionEdge(
    Iterable<Rect> wallRects,
    Rect playerHit,
    Offset speed,
    double dt,
  ) {
    for (final r in wallRects.where((x) => x.overlaps(playerHit))) {
      final edge = _centerCollission(r, playerHit) ??
          _cornerCollission(r, playerHit, speed, dt);
      if (edge != null) return edge;
    }
    return null;
  }

  CollissionEdge _centerCollission(
    Rect r,
    Rect p,
  ) {
    return r.contains(p.topCenter)
        ? CollissionEdge.Top
        : r.contains(p.bottomCenter)
            ? CollissionEdge.Bottom
            : r.contains(p.centerLeft)
                ? CollissionEdge.Left
                : r.contains(p.centerRight) ? CollissionEdge.Right : null;
  }

  CollissionEdge _cornerCollission(
    Rect r,
    Rect p,
    Offset s,
    double dt,
  ) {
    final reversedY = p.translate(0, -(s.dy) * dt);
    final reversedX = p.translate(-(s.dx) * dt, 0);

    if (r.contains(p.topLeft)) {
      if (!r.contains(reversedX.topLeft)) return CollissionEdge.Left;
      if (!r.contains(reversedY.topLeft)) return CollissionEdge.Top;
      assert(false, 'cannot exit top-left collission');
    }
    if (r.contains(p.topRight)) {
      if (!r.contains(reversedX.topRight)) return CollissionEdge.Right;
      if (!r.contains(reversedY.topRight)) return CollissionEdge.Top;
      assert(false, 'cannot exit top-right collission');
    }
    if (r.contains(p.bottomRight)) {
      if (!r.contains(reversedX.bottomRight)) return CollissionEdge.Right;
      if (!r.contains(reversedY.bottomRight)) return CollissionEdge.Bottom;
      assert(false, 'cannot exit bottom-right collission');
    }
    if (r.contains(p.bottomLeft)) {
      if (!r.contains(reversedX.bottomLeft)) return CollissionEdge.Left;
      if (!r.contains(reversedY.bottomLeft)) return CollissionEdge.Bottom;
      assert(false, 'cannot exit bottom-left collission');
    }
    return null;
  }
}
