import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/blackhole/blackhole_model.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

class BlackholeController extends Controller<BlackholeModel> {
  final GetModel<PlayerModel> getPlayerModel;
  final SetModel<PlayerModel> setPlayerModel;

  BlackholeController({
    @required GetModel<BlackholeModel> getModel,
    @required SetModel<BlackholeModel> setModel,
    @required this.getPlayerModel,
    @required this.setPlayerModel,
  }) : super(getModel, setModel);

  void resize(Size deviceSize) {
    final rect = rectFromItem(
      Config.tileSize,
      model.item,
      getModel().scaleFactor,
    );
    updateModel((m) => m.copyWith(rect: rect));
  }

  void update(double dt) {
    // TODO: figure out correct gravitational pull equation and exert pull
    //  _pullPlayer();
  }

  void _pullPlayer() {
    final pm = getPlayerModel();
    final hm = getModel();

    final p = pm.hit.center;
    final h = hm.rect.center;

    final delta = Offset(h.dx - p.dx, h.dy - p.dy);
    final distance = delta.distance;
    final effectiveGravity = hm.gravity / distance;

    setPlayerModel(pm.copyWith(
        speed: pm.speed.translate(
      delta.dx * effectiveGravity,
      delta.dy * effectiveGravity,
    )));
  }
}

class Blackhole extends SpriteComponent {
  final BlackholeController _controller;
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
}
