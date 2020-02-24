import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/game_item.dart';

@immutable
class BlackholeModel {
  final Rect rect;
  final GameItem item;
  final double scaleFactor;

  const BlackholeModel({
    @required this.rect,
    @required this.item,
    @required this.scaleFactor,
  });

  BlackholeModel copyWith({
    Rect rect,
    double scaleFactor,
  }) =>
      BlackholeModel(
        rect: rect ?? this.rect,
        scaleFactor: scaleFactor ?? this.scaleFactor,
        item: this.item,
      );

  String toString() {
    return '''WallModel {
      rect: $rect
    }''';
  }
}
