import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/build_model.dart';
import 'package:ufo_2d/types.dart';

@immutable
class GameModel {
  final Tilemap tilemap;
  final List<TilePosition> floorTiles;
  final List<TilePosition> walls;

  GameModel({
    @required this.tilemap,
    @required this.floorTiles,
    @required this.walls,
  });

  GameModel copyWith() {
    return GameModel(
      tilemap: this.tilemap,
      floorTiles: this.floorTiles,
      walls: this.walls,
    );
  }

  static GameModel _instance;
  static GameModel initFrom(Tilemap tilemap) => _instance = buildModel(tilemap);
  static GetModel<GameModel> getGame = () => _instance;
}
