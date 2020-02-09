import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/level.dart';

@immutable
class PlayerModel {
  final Rect rect;
  final Offset speed;
  final double angle;
  final GameItem item;

  const PlayerModel({
    @required this.rect,
    @required this.speed,
    @required this.angle,
    @required this.item,
  });

  PlayerModel copyWith({
    Rect rect,
    Offset speed,
    double angle,
  }) =>
      PlayerModel(
        rect: rect ?? this.rect,
        speed: speed ?? this.speed,
        angle: angle ?? this.angle,
        item: this.item,
      );

  String toString() {
    return '''PlayerModel {
      rect: $rect
      speed: $speed
    }''';
  }
}
