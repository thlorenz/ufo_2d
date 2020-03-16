import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:ufo_2d/physics/vector.dart';
import 'package:ufo_2d/types.dart';

class PlayerModel {
  final TilePosition tilePosition;
  final Vector velocity;
  final double angle;

  PlayerModel({
    @required this.tilePosition,
    this.angle = 0,
    this.velocity = Vector.zero,
  });

  WorldPosition get worldPosition =>
      WorldPosition.fromTilePosition(tilePosition);

  PlayerModel copyWith({
    TilePosition tilePosition,
    double health,
    Vector velocity,
    double angle,
  }) {
    return PlayerModel(
      tilePosition: tilePosition ?? this.tilePosition,
      velocity: velocity ?? this.velocity,
      angle: angle ?? this.angle,
    );
  }

  @override
  String toString() {
    return '''PlayerModel {
     tilePosition: $tilePosition
     velocity: $velocity
     angle: $angle
   }''';
  }
}
