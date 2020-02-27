import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/game_item.dart';

@immutable
class BlackholeModel {
  final Rect rect;
  final GameItem item;
  final double scaleFactor;
  final double mass;

  const BlackholeModel({
    @required this.rect,
    @required this.item,
    @required this.scaleFactor,
    @required this.mass,
  });

  BlackholeModel copyWith({
    Rect rect,
    double scaleFactor,
  }) =>
      BlackholeModel(
        rect: rect ?? this.rect,
        scaleFactor: scaleFactor ?? this.scaleFactor,
        mass: this.mass,
        item: this.item,
      );

  String toString() {
    return '''BlackholeModel {
      rect: $rect
    }''';
  }
}
