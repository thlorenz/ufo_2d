import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/static/component.dart';

@immutable
class GameModel {
  final PlayerModel player;
  final Rect rect;
  final List<StaticModel> statics;

  const GameModel(
      {@required this.player, @required this.rect, @required this.statics});

  GameModel copyWith({
    PlayerModel player,
    Rect rect,
    List<StaticModel> statics,
  }) =>
      GameModel(
        player: player ?? this.player,
        rect: rect ?? this.rect,
        statics: statics ?? this.statics,
      );

  String toString() {
    return '''GameModel {
      player: $player
      rect: $rect
      statics: $statics
    }''';
  }

  static bool _initialized = false;
  static GameModel _instance;
  static GameModel get instance => _instance;
  static void init(GameModel model) {
    assert(!_initialized, 'game model can only be initialized once');
    _instance = model;
    _initialized = true;
  }

  static void update(GameModel model) {
    _instance = model;
  }
}
