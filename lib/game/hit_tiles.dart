import 'package:flutter/foundation.dart';
import 'package:ufo_2d/admin/game_props.dart';
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

HitTiles getHitTiles(WorldPosition wp) {
  final radius = GameProps.playerHitSize / 2;
  final topLeft = WorldPosition(wp.x - radius, wp.y + radius).toTilePosition();
  final topRight = WorldPosition(wp.x + radius, wp.y + radius).toTilePosition();
  final bottomRight =
      WorldPosition(wp.x + radius, wp.y - radius).toTilePosition();
  final bottomLeft =
      WorldPosition(wp.x - radius, wp.y - radius).toTilePosition();
  return HitTiles(
    topLeft: topLeft,
    topRight: topRight,
    bottomRight: bottomRight,
    bottomLeft: bottomLeft,
  );
}
