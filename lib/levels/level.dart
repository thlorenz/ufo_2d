import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/config.dart';

enum GameItemType { Player, Diamond, HorizontalWall, VerticalWall }

@immutable
class GameItem {
  final String _shortID;
  final int _row;
  final int _col;

  const GameItem(this._shortID, this._row, this._col);

  Rect get rect => Rect.fromLTRB(_col.toDouble(), _row.toDouble(), 1.0, 1.0);

  bool get isPickup => type == GameItemType.Diamond;
  bool get isWall =>
      type == GameItemType.VerticalWall || type == GameItemType.HorizontalWall;

  GameItemType get type {
    switch (_shortID) {
      case 'd':
        return GameItemType.Diamond;
      case 'p':
        return GameItemType.Player;
      case '-':
        return GameItemType.HorizontalWall;
      case '|':
        return GameItemType.VerticalWall;
      default:
        throw new Exception('Unknown game item $_shortID');
    }
  }

  int get score {
    switch (type) {
      case GameItemType.Diamond:
        return Config.pickupScoreDiamond;
      case GameItemType.HorizontalWall:
      case GameItemType.VerticalWall:
      case GameItemType.Player:
        throw Exception('$type is not a pickup and thus has no score');
      default:
        throw Exception('Unknown type $type');
    }
  }

  double get health {
    switch (type) {
      case GameItemType.Diamond:
        return 0;
      case GameItemType.HorizontalWall:
      case GameItemType.VerticalWall:
        return Config.wallHealthFactor;
      case GameItemType.Player:
        throw Exception('$type is never affects its health');
      default:
        throw Exception('Unknown type $type');
    }
  }

  @override
  String toString() {
    return '{ ${type.toString().substring(13)}: $rect }';
  }
}

abstract class GameLevel {
  int _ncols;
  int _nrows;
  List<String> _rows;
  List<GameItem> _items;

  String get terrain;

  GameItem get player {
    final p = items.firstWhere((x) => x.type == GameItemType.Player);
    assert(p != null, 'game items need to include player');
    return p;
  }

  List<GameItem> get items {
    if (_items != null) return _items;

    final gi = List<GameItem>();
    final rs = rows;
    final cs = ncols;
    for (int r = 0; r < rs.length; r++) {
      final row = rs[r];
      for (int c = 0; c < cs; c++) {
        final cell = row[c];
        if (cell == ' ') continue;
        gi.add(GameItem(cell, r, c));
      }
    }
    return (_items = gi);
  }

  List<String> get rows {
    if (_rows != null) return _rows;

    assert(terrain != null, 'need terrain to get rows');
    final allRows = terrain.split('\n');
    // remove empty and ruler rows
    final allLen = allRows.length;
    return _rows = allRows.sublist(1, allLen - 2);
  }

  int get nrows {
    return _nrows ?? (_nrows = rows.length);
  }

  int get ncols {
    if (_ncols != null) return _ncols;
    assert(terrain != null, 'need terrain to get cols');
    final allRows = terrain.split('\n');
    // Skip first empty and ruler lines
    assert(allRows.length > 2, 'need at least two ruler rows get cols');

    // measure first ruler row but leave out | frame i.e. in |01234|
    return _ncols = allRows[0].length;
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
