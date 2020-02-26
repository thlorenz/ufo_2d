import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/stats/stats_model.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/controllers/collissions/collissions_utils.dart';
import 'package:ufo_2d/physics/vector.dart';
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

    final collissionEdge = _getCollissionEdge(wallRects, p, player.velocity, dt);
    if (collissionEdge == null) return;
    double healthToll = 0;
    _updatePlayerModel((m) {
      Vector s = m.velocity;
      Vector ns;
      Rect r = m.rect;
      if (collissionEdge == CollissionEdge.Top ||
          collissionEdge == CollissionEdge.Bottom) {
        ns = Vector(
          s.x * Config.playerHitWallSlowdown,
          -(s.y * Config.playerHitWallSlowdown),
        );
        r = r.translate(s.x * dt, -s.y * dt);
        healthToll = s.y.abs() * Config.wallHealthFactor;
      }
      if (collissionEdge == CollissionEdge.Left ||
          collissionEdge == CollissionEdge.Right) {
        ns = Vector(
          -(s.x * Config.playerHitWallSlowdown),
          s.y * Config.playerHitWallSlowdown,
        );
        r = r.translate(-s.x * dt, s.y * dt);
        healthToll = s.x.abs() * Config.wallHealthFactor;
      }
      if (collissionEdge == CollissionEdge.Stuck) {
        // in the rare case that the player got stuck back out by
        // reversing the movement exactly
        ns = Vector(-(s.x), -(s.y));
        r = r.translate(-s.x * dt * 2, -s.y * dt * 2);
      }
      return m.copyWith(velocity: ns, rect: r);
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
    Vector velocity,
    double dt,
  ) {
    for (final r in wallRects.where((x) => x.overlaps(playerHit))) {
      final edge = centerCollission(r, playerHit) ??
          _cornerCollission(r, playerHit, velocity, dt);
      if (edge != null) return edge;
    }
    return null;
  }

  CollissionEdge _cornerCollission(
    Rect r,
    Rect p,
    Vector s,
    double dt,
  ) {
    final reversedY = p.translate(0, -(s.y) * dt);
    final reversedX = p.translate(-(s.x) * dt, 0);

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
