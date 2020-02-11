import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

enum CollissionEdges { Top, Left, Right, Bottom }

class PlayerCollissionController extends Updater {
  final GetModel<PlayerModel> _getPlayerModel;
  final SetModel<PlayerModel> _setPlayerModel;
  final GetModels<WallModel> _getWallModels;

  PlayerCollissionController(
    this._getPlayerModel,
    this._setPlayerModel,
    this._getWallModels,
  );

  void update(double dt) {
    final walls = this._getWallModels();
    final player = this._getPlayerModel();
    final p = player.hit;
    final wallRects = walls.map((x) => x.rect);

    final collissionEdges = _getCollissionEdges(wallRects, p);
    if (collissionEdges.length == 0) return;

    debugPrint('$collissionEdges');
  }

  Set<CollissionEdges> _getCollissionEdges(Iterable<Rect> wallRects, Rect p) {
    final collissionEdges = Set<CollissionEdges>();

    for (final r in wallRects.where((x) => x.overlaps(p))) {
      _addCollissionEdges(collissionEdges, r, p);

      assert(collissionEdges.length < 4, 'oh my we are stuck');
      if (collissionEdges.length == 3) break;
    }
    return collissionEdges;
  }

  void _addCollissionEdges(
      Set<CollissionEdges> collissionEdges, Rect r, Rect p) {
    if (!collissionEdges.contains(CollissionEdges.Top)) {
      if (r.contains(p.topLeft) ||
          r.contains(p.topRight) ||
          r.contains(p.topCenter)) {
        collissionEdges.add(CollissionEdges.Top);
      }
    }
    if (!collissionEdges.contains(CollissionEdges.Bottom)) {
      if (r.contains(p.bottomLeft) ||
          r.contains(p.bottomRight) ||
          r.contains(p.bottomCenter)) {
        collissionEdges.add(CollissionEdges.Bottom);
      }
    }
    if (!collissionEdges.contains(CollissionEdges.Left)) {
      if (r.contains(p.topLeft) ||
          r.contains(p.centerLeft) ||
          r.contains(p.bottomLeft)) {
        collissionEdges.add(CollissionEdges.Left);
      }
    }
    if (!collissionEdges.contains(CollissionEdges.Right)) {
      if (r.contains(p.topRight) ||
          r.contains(p.centerRight) ||
          r.contains(p.bottomRight)) {
        collissionEdges.add(CollissionEdges.Right);
      }
    }
  }
}
