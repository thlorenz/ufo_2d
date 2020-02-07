import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/level.dart';
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

  TModel init(Size gameSize, GameItem item);

  @mustCallSuper
  void render(Canvas c) {
    view.render(c, getModel());
  }

  @mustCallSuper
  void update(double dt) {
    setModel(controller.update(getModel(), dt));
  }

  @mustCallSuper
  void resize(Size size) {
    super.resize(size);
    final tileSize = getTileSize(size);
    setModel(controller.resize(getModel(), size, tileSize));
  }
}

@immutable
abstract class StaticComponent<TModel, TView extends View<TModel>>
    extends Component {
  final TView view;
  final GetModel<TModel> getModel;
  final SetModel<TModel> setModel;
  final GetTileSize getTileSize;

  StaticComponent({
    @required this.getModel,
    @required this.setModel,
    @required this.view,
    @required this.getTileSize,
  });

  TModel init(Size gameSize, GameItem item);

  @mustCallSuper
  void render(Canvas c) {
    view.render(c, getModel());
  }

  void update(double t) {}
}
