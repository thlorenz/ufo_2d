import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/level.dart';

@immutable
class PlayerModel {
  final Rect rect;
  final Offset speed;
  final double rotation;
  final GameItem item;

  const PlayerModel({
    @required this.rect,
    @required this.speed,
    @required this.rotation,
    @required this.item,
  });

  PlayerModel copyWith({
    Rect rect,
    Offset speed,
    double rotation,
  }) =>
      PlayerModel(
        rect: rect ?? this.rect,
        speed: speed ?? this.speed,
        rotation: rotation ?? this.rotation,
        item: this.item,
      );

  String toString() {
    return '''PlayerModel {
      rect: $rect
      speed: $speed
    }''';
  }
}
