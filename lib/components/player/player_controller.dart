import 'dart:math';
import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/types/interfaces.dart';

class PlayerController implements Controller<PlayerModel> {
  PlayerModel init(Size gameSize) {
    final size = _size(gameSize);
    final pos = _startPosition(gameSize, size);
    final rect = rectFromSize(pos.x, pos.y, size);
    return PlayerModel(rect: rect, speed: Offset(10, 10));
  }

  PlayerModel resize(PlayerModel model, Size gameSize) {
    final x = model.rect;
    final size = _size(gameSize);
    final rect = rectFromSize(x.left, x.top, size);
    return model.copyWith(rect: rect);
  }

  PlayerModel update(PlayerModel model, double dt) {
    final delta = model.speed.scale(dt, dt);
    final rect = model.rect.translate(delta.dx, delta.dy);
    return model.copyWith(rect: rect);
  }

  double _radius(Size gameSize) {
    return min(gameSize.width, gameSize.height) / 12;
  }

  Size _size(Size gameSize) {
    final r = _radius(gameSize);
    final d = r * 2;
    return Size(d, d);
  }

  Point<double> _startPosition(Size gameSize, Size size) {
    final hw = gameSize.width / 2 - size.width / 2;
    final hh = gameSize.height / 2 - size.height / 2;
    return Point(hw, hh);
  }
}
