import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/build_model.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/types.dart';

@immutable
class GameModel {
  final Tilemap tilemap;
  final List<TilePosition> floorTiles;
  final List<TilePosition> walls;
  final List<TilePosition> diamonds;
  final PlayerModel player;

  GameModel({
    @required this.tilemap,
    @required this.floorTiles,
    @required this.walls,
    @required this.diamonds,
    @required this.player,
  });

  GameModel copyWith(PlayerModel player, List<TilePosition> diamonds) {
    return GameModel(
      tilemap: this.tilemap,
      floorTiles: this.floorTiles,
      walls: this.walls,
      diamonds: diamonds ?? this.diamonds,
      player: player ?? this.player,
    );
  }

  static GameModel _instance;
  static GameModel initFrom(Tilemap tilemap) => _instance = buildModel(tilemap);
  static GetModel<GameModel> getGame = () => _instance;
  static GetModel<PlayerModel> getPlayer = () => _instance.player;
}
