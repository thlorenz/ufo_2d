import 'dart:ui';

import 'package:flutter/foundation.dart';
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

    final collissionEdge = _getCollissionEdge(wallRects, p);
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
      debugPrint('$collissionEdge');
      previousCollissionEdge = collissionEdge;
    }
  }

  CollissionEdge _getCollissionEdge(Iterable<Rect> wallRects, Rect p) {
    final collissionEdges = Set<CollissionEdge>();

    for (final r in wallRects.where((x) => x.overlaps(p))) {
      final edge = _centerCollission(r, p) ?? _cornerCollission(r, p);
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
  ) {
    // TODO: we need speed here since when a corner hits there are always two options
    // i.e. top right corner could be hit from the left or the bottom.
    // Try to reverse speed and apply it once + check if now the collission is removed.
    // If not then it should be the other case.
    // When making that choice first try the one that has largest speed vector part, i.e.
    // if abs(dy) > abs(dx) assume first that we're hitting from the bottom.
    return null;
  }
}
