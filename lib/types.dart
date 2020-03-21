import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:ufo_2d/admin/game_props.dart';

typedef GetModel<TModel> = TModel Function();
typedef SetModel<TModel> = void Function(TModel);

@immutable
class TilePosition {
  final int col;
  final int row;
  final double relX;
  final double relY;

  const TilePosition(this.col, this.row, this.relX, this.relY);

  bool isSameTileAs(TilePosition other) =>
      other.col == this.col && other.row == this.row;

  @override
  String toString() {
    return '''TilePosition {
      col: $col + $relX
      row: $row + $relY
    }''';
  }
}

@immutable
class WorldPosition {
  final double x;
  final double y;

  const WorldPosition(this.x, this.y);

  static WorldPosition fromTilePosition(TilePosition tp) {
    final t = GameProps.tileSize;
    final x = t * tp.col + tp.relX;
    final y = t * tp.row + tp.relY;
    return WorldPosition(x, y);
  }

  TilePosition toTilePosition() {
    final t = GameProps.tileSize;
    final col = x ~/ t;
    final row = y ~/ t;
    final relX = x % t;
    final relY = y % t;
    return TilePosition(col, row, relX, relY);
  }

  Offset toOffset() {
    return Offset(x, y);
  }

  Point<double> toPoint() {
    return Point<double>(x, y);
  }

  static WorldPosition fromOffset(Offset offset) {
    return WorldPosition(offset.dx, offset.dy);
  }
}

@immutable
class Tuple<T, U> {
  final T first;
  final U second;
  Tuple(this.first, this.second);
}
