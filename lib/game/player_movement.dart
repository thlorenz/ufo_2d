import 'dart:math';

import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/game/hit_tiles.dart';
import 'package:ufo_2d/models/hud_model.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/physics/vector.dart';
import 'package:ufo_2d/types.dart';

bool _wallAt(TilePosition tilePosition, List<List<bool>> wallTiles) {
  return wallTiles[tilePosition.col][tilePosition.row];
}

WorldPosition _nextPlayerPosition(PlayerModel player) {
  return WorldPosition(
    player.worldPosition.x + player.velocity.x,
    player.worldPosition.y + player.velocity.y,
  );
}

class PlayerMovement {
  static Vector directVelocity(PlayerModel player, double da) {
    final ca = cos(player.angle);
    final sa = sin(player.angle);
    return player.velocity.translate(ca * da, sa * da);
  }

  static Tuple<PlayerModel, HudModel> realizeWallCollission(
    PlayerModel player,
    HudModel hud,
    List<List<bool>> wallTiles,
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

    if (_wallAt(nextHit.bottomRight, wallTiles)) {
      if (_wallAt(nextHit.bottomLeft, wallTiles)) return hitOnAxisY();
      if (_wallAt(nextHit.topRight, wallTiles)) return hitOnAxisX();
      return handleHit(hit.bottomRight, nextHit.bottomRight);
    }
    if (_wallAt(nextHit.topRight, wallTiles)) {
      if (_wallAt(nextHit.topLeft, wallTiles)) return hitOnAxisY();
      if (_wallAt(nextHit.bottomRight, wallTiles)) return hitOnAxisX();
      return handleHit(hit.topRight, nextHit.topRight);
    }
    if (_wallAt(nextHit.bottomLeft, wallTiles)) {
      if (_wallAt(nextHit.topLeft, wallTiles)) return hitOnAxisX();
      return handleHit(hit.bottomLeft, nextHit.bottomLeft);
    }
    if (_wallAt(nextHit.topLeft, wallTiles)) {
      return handleHit(hit.topLeft, nextHit.topLeft);
    }

    return Tuple(player.copyWith(tilePosition: next.toTilePosition()), hud);
  }
}
