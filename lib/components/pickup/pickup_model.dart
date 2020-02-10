import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/level.dart';

@immutable
class PickupModel {
  final Rect rect;
  final GameItem item;

  const PickupModel({
    @required this.rect,
    @required this.item,
  });

  PickupModel copyWith({
    Rect rect,
  }) =>
      PickupModel(
        rect: rect ?? this.rect,
        item: this.item,
      );

  String toString() {
    return '''PickupModel {
      rect: $rect
    }''';
  }
}
