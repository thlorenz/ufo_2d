import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/stats/stats_model.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/controllers/collissions/collissions_utils.dart';
import 'package:ufo_2d/types/typedefs.dart';

class PlayerWallCollission {
  final UpdateModel<PlayerModel> _updatePlayerModel;
  final UpdateModel<StatsModel> _updateStatsModel;
  const PlayerWallCollission(
    this._updatePlayerModel,
    this._updateStatsModel,
  );

  void update(PlayerModel player, List<WallModel> walls, double dt) {
    final p = player.hit;
    final wallRects = walls.map((x) => x.rect);

    final collissionEdge = _getCollissionEdge(wallRects, p, player.speed, dt);
    if (collissionEdge == null) return;
    double healthToll = 0;
    _updatePlayerModel((m) {
      Offset s = m.speed;
      Offset ns;
      Rect r = m.rect;
      if (collissionEdge == CollissionEdge.Top ||
          collissionEdge == CollissionEdge.Bottom) {
        ns = Offset(
          s.dx * Config.playerHitWallSlowdown,
          -(s.dy * Config.playerHitWallSlowdown),
        );
        r = r.translate(s.dx * dt, -s.dy * dt);
        healthToll = s.dy.abs() * Config.wallHealthFactor;
      }
      if (collissionEdge == CollissionEdge.Left ||
          collissionEdge == CollissionEdge.Right) {
        ns = Offset(
          -(s.dx * Config.playerHitWallSlowdown),
          s.dy * Config.playerHitWallSlowdown,
        );
        r = r.translate(-s.dx * dt, s.dy * dt);
        healthToll = s.dx.abs() * Config.wallHealthFactor;
      }
      if (collissionEdge == CollissionEdge.Stuck) {
        // in the rare case that the player got stuck back out by
        // reversing the movement exactly
        ns = Offset(-(s.dx), -(s.dy));
        r = r.translate(-s.dx * dt * 2, -s.dy * dt * 2);
      }
      return m.copyWith(speed: ns, rect: r);
    });
    if (healthToll > 0) {
      _updateStatsModel(
        (m) => m.copyWith(health: m.health - healthToll),
      );
    }
  }

  CollissionEdge _getCollissionEdge(
    Iterable<Rect> wallRects,
    Rect playerHit,
    Offset speed,
    double dt,
  ) {
    for (final r in wallRects.where((x) => x.overlaps(playerHit))) {
      final edge = centerCollission(r, playerHit) ??
          _cornerCollission(r, playerHit, speed, dt);
      if (edge != null) return edge;
    }
    return null;
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
      debugPrint('cannot exit top-left collission');
      return CollissionEdge.Stuck;
    }
    if (r.contains(p.topRight)) {
      if (!r.contains(reversedX.topRight)) return CollissionEdge.Right;
      if (!r.contains(reversedY.topRight)) return CollissionEdge.Top;
      debugPrint('cannot exit top-right collission');
      return CollissionEdge.Stuck;
    }
    if (r.contains(p.bottomRight)) {
      if (!r.contains(reversedX.bottomRight)) return CollissionEdge.Right;
      if (!r.contains(reversedY.bottomRight)) return CollissionEdge.Bottom;
      debugPrint('cannot exit bottom-right collission');
      return CollissionEdge.Stuck;
    }
    if (r.contains(p.bottomLeft)) {
      if (!r.contains(reversedX.bottomLeft)) return CollissionEdge.Left;
      if (!r.contains(reversedY.bottomLeft)) return CollissionEdge.Bottom;
      debugPrint('cannot exit bottom-left collission');
      return CollissionEdge.Stuck;
    }
    return null;
  }
}
