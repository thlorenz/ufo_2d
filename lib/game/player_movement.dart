import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/hit_tiles.dart';
import 'package:ufo_2d/game/walls.dart';
import 'package:ufo_2d/models/hud_model.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/physics/vector.dart';
import 'package:ufo_2d/types.dart';

WorldPosition _nextPlayerPosition(PlayerModel player) {
  return WorldPosition(
    player.worldPosition.x + player.velocity.x,
    player.worldPosition.y + player.velocity.y,
  );
}

class PlayerMovement {
  final Walls walls;

  PlayerMovement({@required this.walls});

  static Vector directVelocity(PlayerModel player, double da) {
    final ca = cos(player.angle);
    final sa = sin(player.angle);
    return player.velocity.translate(ca * da, sa * da);
  }

  Tuple<PlayerModel, HudModel> realizeWallCollission(
    PlayerModel player,
    HudModel hud,
  ) {
    final next = _nextPlayerPosition(player);
    final hit = getHitTiles(player.worldPosition);
    final nextHit = getHitTiles(next);

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

    if (walls.wallAt(nextHit.bottomRight)) {
      if (walls.wallAt(nextHit.bottomLeft)) return hitOnAxisY();
      if (walls.wallAt(nextHit.topRight)) return hitOnAxisX();
      return handleHit(hit.bottomRight, nextHit.bottomRight);
    }
    if (walls.wallAt(nextHit.topRight)) {
      if (walls.wallAt(nextHit.topLeft)) return hitOnAxisY();
      if (walls.wallAt(nextHit.bottomRight)) return hitOnAxisX();
      return handleHit(hit.topRight, nextHit.topRight);
    }
    if (walls.wallAt(nextHit.bottomLeft)) {
      if (walls.wallAt(nextHit.topLeft)) return hitOnAxisX();
      return handleHit(hit.bottomLeft, nextHit.bottomLeft);
    }
    if (walls.wallAt(nextHit.topLeft)) {
      return handleHit(hit.topLeft, nextHit.topLeft);
    }

    return Tuple(player.copyWith(tilePosition: next.toTilePosition()), hud);
  }
}
