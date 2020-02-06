import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

@immutable
abstract class ComponentBase<TModel, TController extends Controller<TModel>,
    TView extends View<TModel>> extends Component {
  final TController controller;
  final TView view;
  final GetModel<TModel> getModel;
  final SetModel<TModel> setModel;

  ComponentBase(this.getModel, this.setModel, this.controller, this.view);

  TModel init(Size gameSize);

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
    setModel(controller.resize(getModel(), size));
  }
}
