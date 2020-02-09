import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/inputs/gestures.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

const tau = 2 * pi;

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
    // TODO: consider Pan updates instead to allow to switch from
    // rotating/speed without lifting finger
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
      final ca = cos(m.angle);
      final sa = sin(m.angle);
      return m.copyWith(speed: m.speed.translate(-sa * a, ca * a));
    });
  }

  void _rotate(double dr) {
    updateModel((m) {
      double r = m.angle + (dr * Config.playerAngleFactor);
      r = r > tau ? r - tau : r;
      return m.copyWith(angle: r);
    });
  }

  void dispose() {
    _rotationSub?.cancel();
    _speedSub?.cancel();
  }
}
