import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/types/typedefs.dart';

abstract class IDisposable {
  void dispose();
}

abstract class Controller<TModel> {
  final GetModel<TModel> getModel;
  final SetModel<TModel> setModel;

  const Controller(this.getModel, this.setModel);

  void updateModel(UpdateModel<TModel> fn) {
    setModel(fn(getModel()));
  }

  void resize(Size deviceSize);
  void update(double dt);

  TModel get model => getModel();
}

@immutable
abstract class View<TModel> {
  void render(Canvas c, TModel model);
}
