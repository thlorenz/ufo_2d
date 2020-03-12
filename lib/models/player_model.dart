import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:ufo_2d/physics/vector.dart';
import 'package:ufo_2d/types.dart';

class PlayerModel {
  final TilePosition tilePosition;
  final Vector velocity;

  PlayerModel({@required this.tilePosition, this.velocity = Vector.zero});

  WorldPosition get worldPosition =>
      WorldPosition.fromTilePosition(tilePosition);

  PlayerModel copyWith({TilePosition tilePosition, Vector velocity}) {
    return PlayerModel(
      tilePosition: tilePosition ?? this.tilePosition,
      velocity: velocity ?? this.velocity,
    );
  }

  @override
  String toString() {
    return '''PlayerModel {
     tilePosition: $tilePosition
     velocity: $velocity
   }''';
  }
}
