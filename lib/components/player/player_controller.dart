import 'dart:math';
import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/types/interfaces.dart';

class PlayerController implements Controller<PlayerModel> {
  PlayerModel init(Size gameSize, Size tileSize) {
    final size = _sizeFromTileSize(tileSize);
    final pos = _startPosition(gameSize, size);
    final rect = rectFromSize(pos.x, pos.y, size);
    return PlayerModel(rect: rect, speed: Offset(0, 0));
  }

  PlayerModel resize(PlayerModel model, Size gameSize, Size tileSize) {
    final x = model.rect;
    final size = _sizeFromTileSize(tileSize);
    final rect = rectFromSize(x.left, x.top, size);
    return model.copyWith(rect: rect);
  }

  PlayerModel update(PlayerModel model, double dt) {
    final delta = model.speed.scale(dt, dt);
    final rect = model.rect.translate(delta.dx, delta.dy);
    return model.copyWith(rect: rect);
  }

  Size _sizeFromTileSize(Size tileSize) {
    final factor = 7;
    return Size(tileSize.width * factor, tileSize.height * factor);
  }

  Point<double> _startPosition(Size gameSize, Size size) {
    final hw = gameSize.width / 2 - size.width / 2;
    final hh = gameSize.height - size.height / 2;
    return Point(hw, hh);
  }
}
