import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/game_item.dart';

@immutable
class WallModel {
  final Rect rect;
  final GameItem item;

  const WallModel({
    @required this.rect,
    @required this.item,
  });

  double get angle {
    return item.type == GameItemType.VerticalWall ? pi : 0;
  }

  WallModel copyWith({
    Rect rect,
  }) =>
      WallModel(
        rect: rect ?? this.rect,
        item: this.item,
      );

  String toString() {
    return '''WallModel {
      rect: $rect
    }''';
  }
}
