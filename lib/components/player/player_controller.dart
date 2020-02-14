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
const minSpeedChangeForEvent = 2.0;

@immutable
class _SpeedChange {
  _SpeedChange(this.a, this.speedFactor);
  final double a;
  final double speedFactor;
}

class PlayerController extends Controller<PlayerModel> implements IDisposable {
  StreamSubscription<double> _rotationSub;
  StreamSubscription<_SpeedChange> _speedSub;

  PlayerController({
    @required GetModel<PlayerModel> getModel,
    @required SetModel<PlayerModel> setModel,
    Stream<DragUpdateDetails> panUpdate$,
    Stream<PhysicalKeyboardKey> keyDown$,
  }) : super(getModel, setModel) {
    final panRotation = (panUpdate$ ?? GameGestures.instance.panUpdate$)
        .where((x) => x.delta.dx.abs() > x.delta.dy.abs())
        .map((x) => x.delta.dx * Config.gesturePlayerRotationFactor);

    final keyboardRotation = (keyDown$ ?? GameKeyboard.instance.keyDown$)
        .map((key) => key == PhysicalKeyboardKey.arrowLeft
            ? -Config.keyboardPlayerRotationStep
            : key == PhysicalKeyboardKey.arrowRight
                ? Config.keyboardPlayerRotationStep
                : 0.0)
        .where((x) => x != 0);

    final panSpeed =
        (panUpdate$ ?? GameGestures.instance.panUpdate$).where((x) {
      if (!Config.playerAcceleratesBackward && x.delta.dy >= 0) return false;
      return x.delta.dy.abs() >= x.delta.dx.abs();
    }).map((x) => _SpeedChange(x.delta.dy, Config.gesturePlayerSpeedFactor));

    final keyboardSpeed = (keyDown$ ?? GameKeyboard.instance.keyDown$)
        .map((key) => key == PhysicalKeyboardKey.arrowUp
            ? _SpeedChange(-1.0, Config.keyboardPlayerSpeedFactor)
            : key == PhysicalKeyboardKey.arrowDown
                ? _SpeedChange(1.0, Config.keyboardPlayerSpeedFactor)
                : null)
        .where((x) => x != null);

    _rotationSub = Rx.merge([panRotation, keyboardRotation]).listen(_rotate);
    _speedSub = Rx.merge([panSpeed, keyboardSpeed]).listen(_changeSpeed);
  }

  void resize(Size deviceSize) {
    updateModel((m) {
      final fromItemRect = rectFromItem(
        Config.tileSize,
        m.item,
        Config.playerScaleFactor,
      );
      // Make sure we preserve player position, i.e. in case of a hot reload
      final rect = Rect.fromLTWH(
        m.rect.left,
        m.rect.top,
        fromItemRect.width,
        fromItemRect.height,
      );
      final hit = hitFrom(rect, Config.playerHitRatio);
      return m.copyWith(rect: rect, hit: hit);
    });
  }

  void update(double dt) {
    updateModel((m) {
      final delta = m.speed.scale(dt, dt);
      final rect = m.rect.translate(delta.dx, delta.dy);
      final hit = hitFrom(rect, Config.playerHitRatio);
      return m.copyWith(rect: rect, hit: hit);
    });
  }

  void _changeSpeed(_SpeedChange sc) {
    updateModel((m) {
      final ca = cos(m.angle);
      final sa = sin(m.angle);
      final da = sc.a * sc.speedFactor;
      final speed = m.speed.translate(-sa * da, ca * da);
      // enforce max speed
      if (speed.distanceSquared > Config.playerMaxSpeed) {
        return m;
      }
      return da.abs() > minSpeedChangeForEvent
          ? m.copyWith(speed: speed, event: PlayerEvent.speedChanged)
          : m.copyWith(speed: speed);
    });
  }

  void _rotate(double dr) {
    updateModel((m) {
      double r = m.angle + dr;
      return m.copyWith(angle: r);
    });
  }

  void dispose() {
    _rotationSub?.cancel();
    _speedSub?.cancel();
  }

  static Rect hitFrom(Rect rect, double hitRatio) {
    return rect.deflate(rect.width * hitRatio);
  }
}
