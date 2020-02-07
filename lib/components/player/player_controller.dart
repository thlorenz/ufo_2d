import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/interfaces.dart';

const scaleFactor = 7;

class PlayerController implements Controller<PlayerModel> {
  PlayerModel init(Size gameSize, Size tileSize, GameItem item) {
    final rect = rectFromItem(tileSize, item, scaleFactor);
    return PlayerModel(rect: rect, speed: Offset(0, 0), item: item);
  }

  PlayerModel resize(PlayerModel model, Size gameSize, Size tileSize) {
    final rect = rectFromItem(tileSize, model.item, scaleFactor);
    return model.copyWith(rect: rect);
  }

  PlayerModel update(PlayerModel model, double dt) {
    final delta = model.speed.scale(dt, dt);
    final rect = model.rect.translate(delta.dx, delta.dy);
    return model.copyWith(rect: rect);
  }
}
