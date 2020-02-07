import 'dart:ui';

import 'package:flutter/foundation.dart';

enum GameItemType { Player, Diamond }

@immutable
class GameItem {
  final String _shortID;
  final int _row;
  final int _col;
  const GameItem(this._shortID, this._row, this._col);

  Rect get rect => Rect.fromLTRB(_col.toDouble(), _row.toDouble(), 1.0, 1.0);

  bool get isStatic => type != GameItemType.Player;

  GameItemType get type {
    switch (_shortID) {
      case 'd':
        return GameItemType.Diamond;
      case 'p':
        return GameItemType.Player;
      default:
        throw new Exception('Unknown game item $_shortID');
    }
  }

  @override
  String toString() {
    return '{ ${type.toString().substring(13)}: $rect }';
  }
}

@immutable
abstract class GameLevel {
  String get terrain;

  GameItem get player {
    final p = items.firstWhere((x) => x.type == GameItemType.Player);
    assert(p != null, 'game items need to include player');
    return p;
  }

  List<GameItem> get items {
    final gi = List<GameItem>();
    final rs = rows;
    final cs = ncols;
    for (int r = 0; r < rs.length; r++) {
      final row = rs[r];
      // skip frame |
      for (int c = 1; c < cs; c++) {
        final cell = row[c];
        if (cell == ' ') continue;
        gi.add(GameItem(cell, r + 1, c));
      }
    }
    return gi;
  }

  List<String> get rows {
    assert(terrain != null, 'need terrain to get rows');
    final allRows = terrain.split('\n');
    // remove empty and ruler rows
    final allLen = allRows.length;
    return allRows.sublist(1, allLen - 2);
  }

  int get nrows {
    return rows.length;
  }

  int get ncols {
    assert(terrain != null, 'need terrain to get cols');
    final allRows = terrain.split('\n');
    // Skip first empty and ruler lines
    assert(allRows.length > 2, 'need at least two ruler rows get cols');

    // measure first ruler row but leave out | frame i.e. in |01234|
    return allRows[0].length - 2;
  }

  @override
  String toString() {
    return '''GameMap {
  rows: $nrows
  cols: $ncols
  items: ${items.map((x) => '\n    $x')}
}''';
  }
}
