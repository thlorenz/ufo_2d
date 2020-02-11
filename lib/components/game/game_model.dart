import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/components/pickup/pickup_model.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/levels/level.dart';

@immutable
class GameModel {
  final PlayerModel player;
  final Rect rect;
  final Rect device;
  final GameLevel level;
  final List<PickupModel> pickups;
  final List<WallModel> walls;

  const GameModel({
    @required this.player,
    @required this.rect,
    @required this.level,
    @required this.device,
    @required this.pickups,
    @required this.walls,
  });

  GameModel copyWith({
    PlayerModel player,
    Rect rect,
    Rect device,
    List<PickupModel> pickups,
    List<WallModel> walls,
  }) =>
      GameModel(
        level: this.level,
        player: player ?? this.player,
        rect: rect ?? this.rect,
        device: device ?? this.device,
        pickups: pickups ?? this.pickups,
        walls: walls ?? this.walls,
      );

  String toString() {
    return '''GameModel {
      player: $player
      device: $device
      rect: $rect
      statics: $pickups
      walls: $walls
    }''';
  }

  static GameModel _instance;
  static GameModel get instance => _instance;
  static void set(GameModel model) {
    _instance = model;
  }

  static PlayerModel getPlayer() => GameModel.instance.player;
  static void setPlayer(PlayerModel player) =>
      GameModel.set(GameModel.instance.copyWith(player: player));

  static List<WallModel> getWalls() => GameModel.instance.walls;
  static List<PickupModel> getPickups() => GameModel.instance.pickups;
}
