import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/components/player/player_model.dart';

@immutable
class GameModel {
  final PlayerModel player;
  final Rect rect;

  const GameModel({@required this.player, @required this.rect});

  GameModel copyWith({PlayerModel player, Rect rect}) => GameModel(
        player: player ?? this.player,
        rect: rect ?? this.rect,
      );

  String toString() {
    return '''GameModel {
      player: $player
      rect: $rect
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
