import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/inputs/gestures.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

class PlayerController extends Controller<PlayerModel> implements IDisposable {
  StreamSubscription<double> _rotationSub;
  StreamSubscription<double> _speedSub;

  PlayerController({
    @required GetModel<PlayerModel> getModel,
    @required SetModel<PlayerModel> setModel,
    @required PlayerModel model,
    Stream<DragUpdateDetails> horizontalDragUpdate$,
    Stream<DragUpdateDetails> verticalDragUpdate$,
  }) : super(getModel, setModel) {
    _rotationSub = horizontalDragUpdate$ ??
        GameGestures.instance.horizontalDragUpdate$
            .map((x) => x.primaryDelta)
            .listen(_rotate);
    _speedSub = verticalDragUpdate$ ??
        GameGestures.instance.verticalDragUpdate$
            .map((x) => x.primaryDelta)
            .listen(_changeSpeed);
  }

  void resize(Size deviceSize) {
    final rect = rectFromItem(
      Config.tileSize,
      model.item,
      Config.playerScaleFactor,
    );
    updateModel((m) => m.copyWith(rect: rect));
  }

  void update(double dt) {
    updateModel((m) {
      final delta = m.speed.scale(dt, dt);
      final rect = m.rect.translate(delta.dx, delta.dy);
      return m.copyWith(rect: rect);
    });
  }

  void _changeSpeed(double a) {
    updateModel((m) {
      // TODO: take rotation into account
      return m.copyWith(speed: m.speed.translate(0, a));
    });
  }

  void _rotate(double dr) {
    updateModel((m) => m.copyWith(
          rotation: m.rotation + (dr * Config.playerRotationFactor),
        ));
  }

  void dispose() {
    _rotationSub?.cancel();
    _speedSub?.cancel();
  }
}
