/*
 * Sample terrain
|0123456789012345678901234567890|
(-------------------------------)
(                               )
(                               )
(                               )
(--------                       )
        (                       --------)
        (                               )
        (         -------               )
        (         |     |               )
        (         |     |               )
        (         |     |               )
        (         -------               )
        (                               )
(--------                       --------)
(        d                      )
(                               )
(                  p            )
(-------------------------------)
|0123456789012345678901234567890|
 */

import 'dart:math';

enum Tile {
  /* 0 */ OutOfBounds,
  /* 1 */ Empty,
  /* 2 */ Boundary,
  /* 4 */ Wall,
  /* 5 */ Player,
}

const charToTile = <String, Tile>{
  ' ': Tile.Empty,
  'p': Tile.Player,
  '(': Tile.Boundary,
  ')': Tile.Boundary,
  '|': Tile.Wall,
  '-': Tile.Wall,
};

Tile tileFromChar(String char) {
  final tile = charToTile[char];
  assert(tile != null, '$char needs to be in charToTile map');
  return tile;
}

class Tilemap {
  final List<Tile> tiles;
  // length x
  final int ncols;
  // length y
  final int nrows;

  Tilemap(this.tiles, this.nrows, this.ncols);

  @override
  String toString() {
    return '''Tilemap {
ncols: $ncols
nrows: $nrows
tiles: $_tilesString
}''';
  }

  String get _tilesString {
    assert(tiles.length == nrows * ncols, 'incorrectly sized tiles');
    String s = '';
    for (int row = 0; row < nrows; row++) {
      s += '\n';
      for (int col = 0; col < ncols; col++) {
        final tile = tiles[row * ncols + col];
        final idx = Tile.values.indexOf(tile);
        final char =
            tile == Tile.OutOfBounds ? 'x' : tile == Tile.Empty ? ' ' : idx;
        s += '$char ';
      }
    }
    return s;
  }
}

Tilemap build(String terrain) {
  final allLines = terrain.split('\n');
  final lines = allLines.getRange(1, allLines.length - 2).toList();

  // always skip start and end rulers
  int nrows = lines.length;
  int ncols = 0;
  for (final line in lines) {
    ncols = max(line.length, ncols);
  }

  final ntiles = nrows * ncols;
  final tiles = List<Tile>(ntiles)..fillRange(0, ntiles, Tile.OutOfBounds);

  for (int row = 0; row < lines.length; row++) {
    final line = lines[row];
    for (int col = 0; col < line.length; col++) {
      tiles[row * ncols + col] = tileFromChar(line[col]);
    }
  }
  return Tilemap(tiles, nrows, ncols);
}

final terrain = ('''
|012345678901234567894|
(---------------------)
(                     )
(                     )
(                     )
(     |--|            )
(     |  |            )
(     |--|            )
(                     ---)
(       p                )
(                     ---)
(---------------------)
|012345678901234567890|
''');

void main() {
  final tilemap = build(terrain);
  print('$tilemap');
}
