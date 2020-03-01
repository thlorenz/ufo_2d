import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/types.dart';

class Player {
  final GetModel<PlayerModel> _getModel;
  final Sprite _sprite;
  Player(this._getModel) : _sprite = Sprite('ufo.png');

  void render(Canvas canvas) {
    final wp = _getModel().worldPosition;
    final w = GameProps.tileSize;
    final c = GameProps.tileCenter;
    final rect = Rect.fromLTWH(wp.x - c, wp.y - c, w, w);
    _sprite.renderRect(canvas, rect);
  }
}
