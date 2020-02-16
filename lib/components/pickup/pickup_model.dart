import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/level.dart';

@immutable
class PickupModel {
  final Rect rect;
  final GameItem item;
  final bool pickedUp;

  const PickupModel(
      {@required this.rect, @required this.item, @required this.pickedUp});

  int get score {
    return this.item.score;
  }

  double get health {
    return this.item.health;
  }

  PickupModel copyWith({
    Rect rect,
    bool pickedUp,
  }) =>
      PickupModel(
        rect: rect ?? this.rect,
        pickedUp: pickedUp ?? this.pickedUp,
        item: this.item,
      );

  String toString() {
    return '''PickupModel {
      rect: $rect
    }''';
  }
}
