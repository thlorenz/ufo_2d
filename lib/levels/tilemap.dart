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
  Empty, // 0
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
        s += '$idx ';
      }
    }
    return s;
  }
}

Tilemap build(String terrain) {
  final lines = terrain.split('\n').where((x) => x.trim().isNotEmpty).toList();
  int nrows = lines.length;
  int ncols = 0;
  for (final line in lines) {
    ncols = max(line.length, ncols);
  }

  final ntiles = nrows * ncols;
  final tiles = List<Tile>(ntiles)..fillRange(0, ntiles, Tile.Empty);
  return Tilemap(tiles, nrows, ncols);
}

final terrain = ('''
|012345678901234567894|
(---------------------)
(                     )
(                     )
(              p      )
(                     )
(                     )
(                     )
(                     )
(                     )
(---------------------)
|012345678901234567890|
''');

void main() {
  final tilemap = build(terrain);
  print('$tilemap');
}
