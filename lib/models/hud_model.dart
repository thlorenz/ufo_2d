import 'package:flutter/foundation.dart';

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
