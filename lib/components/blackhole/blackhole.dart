import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/blackhole/blackhole_model.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/physics/vector.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

class BlackholeController extends Controller<BlackholeModel> {
  final GetModel<PlayerModel> getPlayerModel;
  final SetModel<PlayerModel> setPlayerModel;
  Vector _playerDirection;
  double _forceOnPlayer;

  BlackholeController({
    @required GetModel<BlackholeModel> getModel,
    @required SetModel<BlackholeModel> setModel,
    @required this.getPlayerModel,
    @required this.setPlayerModel,
  }) : super(getModel, setModel);

  Vector get playerDirection => _playerDirection;
  double get forceOnPlayer => _forceOnPlayer;

  void resize(Size deviceSize) {
    final rect = rectFromItem(
      Config.tileSize,
      model.item,
      getModel().scaleFactor,
    );
    updateModel((m) => m.copyWith(rect: rect));
  }

  void update(double dt) {
    final pm = getPlayerModel();
    final hm = getModel();
    _playerDirection = _calcPlayerDirection(pm, hm);
    // We are inside teh black hole
    if (_playerDirection.magnitude < 10) {
      setPlayerModel(
        pm.copyWith(velocity: Vector(0, 0)),
      );
      return;
    }
    _forceOnPlayer = _calcForceOnPlayer(hm) * dt;
    final pull = _playerDirection.normalized.reversed
        .scale(_forceOnPlayer, _forceOnPlayer);
    final vec = pm.velocity.translate(pull.x, pull.y);
    setPlayerModel(pm.copyWith(velocity: vec));
  }

  Vector _calcPlayerDirection(PlayerModel pm, BlackholeModel hm) {
    final playerPos = Point(pm.rect.center.dx, pm.rect.center.dy);
    final holePos = Point(hm.rect.center.dx, hm.rect.center.dy);

    return Vector.fromPoints(holePos, playerPos);
  }

  double _calcForceOnPlayer(BlackholeModel hm) {
    final radiusSquared = _playerDirection.magnitudeSquared;
    final mass = hm.mass;
    return (Config.bigG * mass) / radiusSquared;
  }

  /*
  // TODO: figure out correct gravitational pull equation and exert pull
  void _pullPlayer() {
    final pm = getPlayerModel();
    final hm = getModel();

    final p = pm.hit.center;
    final h = hm.rect.center;

    final delta = Offset(h.dx - p.dx, h.dy - p.dy);
    final distance = delta.distance;
    final effectiveGravity = hm.gravity / distance;

    setPlayerModel(pm.copyWith(
        velocity: pm.velocity.translate(
      delta.dx * effectiveGravity,
      delta.dy * effectiveGravity,
    )));
  }
  */
}

class Blackhole extends SpriteComponent {
  final BlackholeController _controller;
  final _debugVector = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke;
  final _debugForce = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke;

  Blackhole(this._controller) {
    sprite = Sprite('static/blackhole.png');
    anchor = Anchor.center;
  }

  void resize(Size size) {
    _controller.resize(size);
    setByRect(_controller.model.rect);
  }

  void update(double t) {
    angle = angle + t;
    _controller.update(t);
    super.update(t);
  }

  void render(Canvas c) {
    c.save();
    super.render(c);
    c.restore();
    if (Config.debugBlackholePull) this._showClosePlayerDirection(c);
  }

  void _showClosePlayerDirection(Canvas c) {
    final direction = _controller.playerDirection;
    if (direction.magnitude > 50000) return;
    final center = _controller.model.rect.center;
    final playerCenter = center.translate(direction.x, direction.y);

    c.drawLine(
      center,
      playerCenter,
      _debugVector..strokeWidth = 5000 / direction.magnitude,
    );
    c.drawCircle(center, 5.0, Config.debugVector);
    c.drawLine(
      center,
      playerCenter,
      _debugForce..strokeWidth = 10 * _controller.forceOnPlayer,
    );
  }
}
