import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/level.dart';

@immutable
class PlayerModel {
  final Rect rect;
  final Rect hit;
  final Offset speed;
  final double angle;
  final GameItem item;

  const PlayerModel({
    @required this.rect,
    @required this.hit,
    @required this.speed,
    @required this.angle,
    @required this.item,
  });

  PlayerModel copyWith({
    Rect rect,
    Rect hit,
    Offset speed,
    double angle,
  }) =>
      PlayerModel(
        rect: rect ?? this.rect,
        hit: hit ?? this.hit,
        speed: speed ?? this.speed,
        angle: angle ?? this.angle,
        item: this.item,
      );

  String toString() {
    return '''PlayerModel {
      rect: $rect
      hit: $hit
      speed: $speed
    }''';
  }
}
