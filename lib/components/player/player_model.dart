import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/level.dart';

@immutable
class PlayerModel {
  final Rect rect;
  final Offset speed;
  final GameItem item;

  const PlayerModel({
    @required this.rect,
    @required this.speed,
    @required this.item,
  });

  PlayerModel copyWith({Rect rect, Offset speed}) => PlayerModel(
        rect: rect ?? this.rect,
        speed: speed ?? this.speed,
        item: this.item,
      );

  String toString() {
    return '''PlayerModel {
      rect: $rect
      speed: $speed
    }''';
  }
}
