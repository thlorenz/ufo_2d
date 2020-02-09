import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/types/interfaces.dart';

class GameController extends Controller<GameModel> {
  GameController() : super(() => GameModel.instance, GameModel.set);

  void resize(Size deviceSize) {
    updateModel((m) {
      final Rect x = m.rect;
      return m.copyWith(device: rectFromSize(x.left, x.top, deviceSize));
    });
  }

  void update(double dt) {}
}
