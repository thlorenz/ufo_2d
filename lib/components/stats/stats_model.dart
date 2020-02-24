import 'package:flutter/foundation.dart';

@immutable
class StatsModel {
  final int score;
  final double health;

  StatsModel({
    @required this.score,
    @required this.health,
  });

  StatsModel copyWith({
    int score,
    double health,
  }) {
    return StatsModel(
      score: score ?? this.score,
      health: health ?? this.health,
    );
  }

  static StatsModel get empty {
    return StatsModel(score: 0, health: 100);
  }

  String toString() {
    return '''StatsModel {
      score: $score
      health: $health
    }''';
  }
}
