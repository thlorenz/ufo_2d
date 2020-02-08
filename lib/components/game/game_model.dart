import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/static/component.dart';
import 'package:ufo_2d/levels/level.dart';

@immutable
class GameModel {
  final PlayerModel player;
  final Rect rect;
  final Rect device;
  final GameLevel level;
  final List<StaticModel> statics;

  const GameModel({
    @required this.player,
    @required this.rect,
    @required this.level,
    @required this.device,
    @required this.statics,
  });

  GameModel copyWith({
    PlayerModel player,
    Rect rect,
    Rect device,
    List<StaticModel> statics,
  }) =>
      GameModel(
        level: this.level,
        player: player ?? this.player,
        rect: rect ?? this.rect,
        device: device ?? this.device,
        statics: statics ?? this.statics,
      );

  String toString() {
    return '''GameModel {
      player: $player
      device: $device
      rect: $rect
      statics: $statics
    }''';
  }

  static bool _initialized = false;
  static GameModel _instance;
  static GameModel get instance => _instance;
  static void init(GameModel model) {
    // assert(!_initialized, 'game model can only be initialized once');
    _instance = model;
    _initialized = true;
  }

  static void update(GameModel model) {
    _instance = model;
  }
}
