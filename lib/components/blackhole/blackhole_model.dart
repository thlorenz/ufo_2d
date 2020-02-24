import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/game_item.dart';

@immutable
class BlackholeModel {
  final Rect rect;
  final GameItem item;
  final double scaleFactor;
  final double gravity;

  const BlackholeModel({
    @required this.rect,
    @required this.item,
    @required this.scaleFactor,
    @required this.gravity,
  });

  BlackholeModel copyWith({
    Rect rect,
    double scaleFactor,
  }) =>
      BlackholeModel(
        rect: rect ?? this.rect,
        scaleFactor: scaleFactor ?? this.scaleFactor,
        gravity: this.gravity,
        item: this.item,
      );

  String toString() {
    return '''BlackholeModel {
      rect: $rect
    }''';
  }
}
