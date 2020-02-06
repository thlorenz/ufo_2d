import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class PlayerModel {
  final Rect rect;
  final Offset speed;

  const PlayerModel({@required this.rect, @required this.speed});

  PlayerModel copyWith({Rect rect, Offset speed}) => PlayerModel(
        rect: rect ?? this.rect,
        speed: speed ?? this.speed,
      );

  String toString() {
    return '''PlayerModel {
      rect: $rect
      speed: $speed
    }''';
  }
}
