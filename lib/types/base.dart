import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/game_item.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

@immutable
abstract class DynamicComponent<TModel, TController extends Controller<TModel>,
    TView extends View<TModel>> extends Component {
  final TController controller;
  final TView view;
  final GetModel<TModel> getModel;
  final SetModel<TModel> setModel;
  final GetTileSize getTileSize;

  DynamicComponent({
    @required this.getModel,
    @required this.setModel,
    @required this.controller,
    @required this.view,
    @required this.getTileSize,
  });

  TModel init(Size tileSize, GameItem item);

  @mustCallSuper
  void render(Canvas c) {
    view.render(c, getModel());
  }

  @mustCallSuper
  void update(double dt) {
    controller.update(dt);
  }

  @mustCallSuper
  void resize(Size deviceSize) {
    super.resize(deviceSize);
    controller.resize(deviceSize);
  }
}

@immutable
abstract class StaticComponent<TModel, TView extends View<TModel>>
    extends Component {
  final TView view;
  final GetModel<TModel> getModel;
  final SetModel<TModel> setModel;

  StaticComponent({
    @required this.getModel,
    @required this.setModel,
    @required this.view,
  });

  TModel init(Size gameSize, GameItem item);

  @mustCallSuper
  void render(Canvas c) {
    view.render(c, getModel());
  }

  void update(double t) {}
}
