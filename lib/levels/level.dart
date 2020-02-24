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

import 'package:flutter/cupertino.dart';
import 'package:ufo_2d/levels/game_item.dart';
import 'package:ufo_2d/types/typedefs.dart';

@immutable
class _RowItem {
  final int colIdx;
  final String shortID;
  const _RowItem(this.colIdx, this.shortID);

  static _RowItem boundary(int colIdx) => _RowItem(colIdx, '|');
}

@immutable
class _Row {
  final int startIdx;
  final int endIdx;
  final List<_RowItem> items;
  const _Row(this.startIdx, this.endIdx, this.items);
}

class GameLevel {
  final String terrain;
  Tuple<int, int> _levelSize;
  List<GameItem> _items;


  GameLevel(this.terrain) {
    assert(terrain != null, 'need terrain to build level');
    this._init();
  }

  Tuple<int, int> get levelSize => _levelSize;
  List<GameItem> get items => _items;
  int get ncols => _levelSize.first;
  int get nrows => _levelSize.second;

  GameItem get player {
    final p = items.firstWhere((x) => x.type == GameItemType.Player);
    assert(p != null, 'game items need to include player');
    return p;
  }

  _init() {
    final lines = terrain.split('\n').map((x) => x.trim()).where((x) => x.isNotEmpty).toList();
    final List<_Row> rows = lines.getRange(1, lines.length - 1).map(_extractRow).toList();
    final w = rows
      .map((x) => x.endIdx)
      .fold(0, (m, x) =>  max<int>(m, x));
    final h = rows.length;

    _levelSize = Tuple(w, h);
    _items = _buildGameItems(rows);
  }

  _Row _extractRow(String line) {
    int startIdx = line.indexOf('(');
    int endIdx = line.indexOf(')');
    assert(startIdx >= 0, 'each row needs to have ( to indicate start');
    assert(endIdx > startIdx, 'each row needs to have ) to the right of (');

    List<_RowItem> items = List();
    items.add(_RowItem.boundary(startIdx));
    for (int i = startIdx + 1; i < endIdx; i++) {
      if (line[i] != ' ') items.add(_RowItem(i, line[i]));
    }
    items.add(_RowItem.boundary(endIdx));
    return _Row(startIdx, endIdx, items);
  }

  List<GameItem> _buildGameItems(List<_Row> rows) {
    final gis = List<GameItem>();
    for (int r = 0; r < rows.length; r++) {
      final row = rows[r];
      for (var item in row.items) {
        final gi = GameItem.create(item.shortID, r, item.colIdx);
        gis.add(gi);
      }
    }
    return gis;
  }
}