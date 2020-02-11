import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/inputs/gestures.dart';
import 'package:ufo_2d/inputs/keyboard.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

const tau = 2 * pi;
const keyboardRotationStep = 5.0;
const keyboardSpeedStep = 10.0;

class PlayerController extends Controller<PlayerModel> implements IDisposable {
  StreamSubscription<double> _rotationSub;
  StreamSubscription<double> _speedSub;

  PlayerController({
    @required GetModel<PlayerModel> getModel,
    @required SetModel<PlayerModel> setModel,
    Stream<DragUpdateDetails> panUpdate$,
    Stream<PhysicalKeyboardKey> keyDown$,
  }) : super(getModel, setModel) {
    final panRotation = (panUpdate$ ?? GameGestures.instance.panUpdate$)
        .where((x) => x.delta.dx.abs() > x.delta.dy.abs())
        .map((x) => x.delta.dx);
    final keyboardRotation = (keyDown$ ?? GameKeyboard.instance.keyDown$)
        .map((key) => key == PhysicalKeyboardKey.arrowLeft
            ? -keyboardRotationStep
            : key == PhysicalKeyboardKey.arrowRight
                ? keyboardRotationStep
                : 0.0)
        .where((x) => x != 0);

    final panSpeed = (panUpdate$ ?? GameGestures.instance.panUpdate$)
        .where((x) => x.delta.dy.abs() >= x.delta.dx.abs())
        .map((x) => x.delta.dy);
    final keyboardSpeed = (keyDown$ ?? GameKeyboard.instance.keyDown$)
        .map((key) => key == PhysicalKeyboardKey.arrowUp
            ? -keyboardSpeedStep
            : key == PhysicalKeyboardKey.arrowDown ? keyboardSpeedStep : 0.0)
        .where((x) => x != 0);

    _rotationSub = Rx.merge([panRotation, keyboardRotation]).listen(_rotate);
    _speedSub = Rx.merge([panSpeed, keyboardSpeed]).listen(_changeSpeed);
  }

  void resize(Size deviceSize) {
    updateModel((m) {
      final rect = rectFromItem(
        Config.tileSize,
        m.item,
        Config.playerScaleFactor,
      );
      final hit = _hitFrom(rect);
      return m.copyWith(rect: rect, hit: hit);
    });
  }

  void update(double dt) {
    updateModel((m) {
      final delta = m.speed.scale(dt, dt);
      final rect = m.rect.translate(delta.dx, delta.dy);
      final hit = _hitFrom(rect);
      return m.copyWith(rect: rect, hit: hit);
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

  Rect _hitFrom(Rect rect) {
    return rect.deflate(rect.width * Config.playerHitRatio);
  }

  void dispose() {
    _rotationSub?.cancel();
    _speedSub?.cancel();
  }
}
