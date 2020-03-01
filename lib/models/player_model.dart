import 'package:flutter/foundation.dart';
import 'package:ufo_2d/types.dart';

class PlayerModel {
  final TilePosition tilePosition;

  PlayerModel({@required this.tilePosition});

  WorldPosition get worldPosition =>
      WorldPosition.fromTilePosition(tilePosition);

  PlayerModel copyWith({TilePosition tilePosition}) {
    return PlayerModel(tilePosition: tilePosition ?? this.tilePosition);
  }
}
