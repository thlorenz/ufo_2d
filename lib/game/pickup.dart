import 'package:flutter/foundation.dart';

enum PickupType { Diamond, Medkit }

class Pickup {
  final int score;
  final double health;
  final PickupType type;
  Pickup({this.score = 0, this.health = 0, @required this.type});

  bool get hasScore => score != 0;
  bool get hasHealth => health != 0;
}
