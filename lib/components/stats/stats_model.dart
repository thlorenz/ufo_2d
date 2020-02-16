import 'package:flutter/foundation.dart';

@immutable
class StatsModel {
  final int score;
  final int playerHealth;
  final double fps;

  StatsModel({
    @required this.score,
    @required this.playerHealth,
    @required this.fps,
  });

  StatsModel copyWith({
    int score,
    int playerHealth,
    double fps,
  }) {
    return StatsModel(
      score: score ?? this.score,
      playerHealth: playerHealth ?? this.playerHealth,
      fps: fps ?? this.fps,
    );
  }

  String toString() {
    return '''StatsModel {
      score: $score
      playerHealth: $playerHealth
      fps: $fps
    }''';
  }
}
