import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/game_model.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/types.dart';

GameModel buildModel(Tilemap tilemap) {
  final nrows = tilemap.nrows;
  final ncols = tilemap.ncols;
  final center = GameProps.tileSize / 2;

  final floorTiles = List<TilePosition>();
  final walls = List<TilePosition>();
  PlayerModel player;

  for (int row = 0; row < nrows; row++) {
    for (int col = 0; col < ncols; col++) {
      final tile = tilemap.tiles[row * ncols + col];
      if (!Tilemap.coversBackground(tile)) {
        floorTiles.add(TilePosition(col, row, center, center));
      }
      if (tile == Tile.Wall || tile == Tile.Boundary) {
        walls.add(TilePosition(col, row, center, center));
      }
      if (tile == Tile.Player) {
        player = PlayerModel(
          tilePosition: TilePosition(col, row, center, center),
        );
      }
    }
  }
  assert(player != null, 'need to include a player');
  return GameModel(
    tilemap: tilemap,
    floorTiles: floorTiles,
    walls: walls,
    player: player,
  );
}
