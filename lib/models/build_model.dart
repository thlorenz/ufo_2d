import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/game_model.dart';
import 'package:ufo_2d/models/hud_model.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/types.dart';

GameModel buildModel(Tilemap tilemap) {
  final nrows = tilemap.nrows;
  final ncols = tilemap.ncols;
  final center = GameProps.tileSize / 2;

  final floorTiles = List<TilePosition>();
  final walls = List<TilePosition>();
  final List<List<bool>> wallTiles = List.generate(
    ncols,
    (_) => List(nrows)..fillRange(0, nrows, false),
  );
  final diamonds = List<TilePosition>();
  final medkits = List<TilePosition>();
  PlayerModel player;

  for (int col = 0; col < ncols; col++) {
    for (int row = 0; row < nrows; row++) {
      final tile = tilemap.tiles[row * ncols + col];
      if (!Tilemap.coversBackground(tile)) {
        floorTiles.add(TilePosition(col, row, center, center));
      }
      if (tile == Tile.Wall || tile == Tile.Boundary) {
        walls.add(TilePosition(col, row, center, center));
        wallTiles[col][row] = true;
      }
      if (tile == Tile.Diamond) {
        diamonds.add(TilePosition(col, row, center, center));
      }
      if (tile == Tile.Medkit) {
        medkits.add(TilePosition(col, row, center, center));
      }
      if (tile == Tile.Player) {
        player = PlayerModel(
          tilePosition: TilePosition(col, row, center, center),
        );
      }
    }
  }
  assert(player != null, 'need to include a player');

  final hud = HudModel(health: GameProps.playerTotalHealth, score: 0);
  return GameModel(
    tilemap: tilemap,
    floorTiles: floorTiles,
    walls: walls,
    wallTiles: wallTiles,
    diamonds: diamonds,
    medkits: medkits,
    player: player,
    hud: hud,
  );
}
