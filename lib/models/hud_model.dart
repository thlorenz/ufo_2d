import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/admin/game_props.dart';

@immutable
class HudModel {
  final int score;
  final double health;

  HudModel({
    @required this.score,
    @required this.health,
  });

  HudModel copyWith({
    int score,
    double health,
  }) {
    if (health != null) health = min(health, GameProps.playerTotalHealth);
    return HudModel(
      score: score ?? this.score,
      health: health ?? this.health,
    );
  }

  static HudModel get empty {
    return HudModel(score: 0, health: 100);
  }

  String toString() {
    return '''StatsModel {
      score: $score
      health: $health
    }''';
  }
}
