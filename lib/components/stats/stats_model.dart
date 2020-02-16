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

  String toString() {
    return '''StatsModel {
      score: $score
      health: $health
    }''';
  }
}
