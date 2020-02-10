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
    Stream<DragUpdateDetails> panUpdate$,
  }) : super(getModel, setModel) {
    _rotationSub = panUpdate$ ??
        GameGestures.instance.panUpdate$
            .where((x) => x.delta.dx.abs() > x.delta.dy.abs())
            .map((x) => x.delta.dx)
            .listen(_rotate);
    _speedSub = panUpdate$ ??
        GameGestures.instance.panUpdate$
            .where((x) => x.delta.dy.abs() >= x.delta.dx.abs())
            .map((x) => x.delta.dy)
            .listen(_changeSpeed);
  }

  void resize(Size deviceSize) {
    updateModel((m) {
      final rect = rectFromItem(
        Config.tileSize,
        m.item,
        Config.playerScaleFactor,
      );
      return m.copyWith(rect: rect);
    });
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
      final da = a * Config.playerSpeedFactor;
      return m.copyWith(speed: m.speed.translate(-sa * da, ca * da));
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
