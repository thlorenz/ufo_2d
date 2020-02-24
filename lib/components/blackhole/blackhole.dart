import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/blackhole/blackhole_model.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

class BlackholeController extends Controller<BlackholeModel> {
  BlackholeController({
    @required GetModel<BlackholeModel> getModel,
    @required SetModel<BlackholeModel> setModel,
  }) : super(getModel, setModel);

  void resize(Size deviceSize) {
    final rect = rectFromItem(
      Config.tileSize,
      model.item,
      getModel().scaleFactor,
    );
    updateModel((m) => m.copyWith(rect: rect));
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
    super.update(t);
  }
}
