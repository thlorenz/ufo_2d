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
  /* 3 */ Wall,
  /* 4 */ Player,
}

const BOUNDS_START = '(';
const BOUNDS_END = ')';
const EMPTY = ' ';
const charToTile = <String, Tile>{
  BOUNDS_START: Tile.Boundary,
  BOUNDS_END: Tile.Boundary,
  EMPTY: Tile.Empty,
  'p': Tile.Player,
  '|': Tile.Wall,
  '-': Tile.Wall,
};

Tile _tileFromChar(String char) {
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

  static Tilemap build(String terrain) {
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
      bool seenBoundsStart = false;
      bool seenBoundsEnd = false;
      for (int col = 0; col < line.length; col++) {
        final char = line[col];
        seenBoundsStart = seenBoundsStart || char == BOUNDS_START;
        seenBoundsEnd = seenBoundsEnd || char == BOUNDS_END;
        if ((!seenBoundsStart || seenBoundsEnd) && char == EMPTY) {
          tiles[row * ncols + col] = Tile.OutOfBounds;
        } else {
          tiles[row * ncols + col] = _tileFromChar(char);
        }
      }
    }
    return Tilemap(tiles, nrows, ncols);
  }

  static bool coversBackground(Tile tile) {
    switch (tile) {
      case Tile.OutOfBounds:
      case Tile.Boundary:
      case Tile.Wall:
        return true;
      case Tile.Empty:
      case Tile.Player:
        return false;
      default:
        throw Exception('Unknown tile type $tile');
    }
  }

  @override
  String toString() {
    return '''Tilemap ($ncols x $nrows)
$_tilesString
''';
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
            tile == Tile.OutOfBounds ? 'X' : tile == Tile.Empty ? ' ' : idx;
        s += '$char ';
      }
    }
    return s;
  }
}

final terrain = ('''
|012345678901234567894|
(---------------------)
(                     )
(                     )
(----                 )
    (     |--|        )
    (     |  |        )
    (     |--|        )
(----                 ---)
(       p                )
(                     ---)
(---------------------)
|012345678901234567890|
''');

void main() {
  final tilemap = Tilemap.build(terrain);
  print('$tilemap');
}
