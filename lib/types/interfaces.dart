import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/types/typedefs.dart';

abstract class IDisposable {
  void dispose();
}

abstract class Updater {
  const Updater();
  void update(double dt) {}
}

abstract class Controller<TModel> extends Updater {
  final GetModel<TModel> getModel;
  final SetModel<TModel> setModel;

  const Controller(this.getModel, this.setModel) : super();

  void updateModel(ModelUpdate<TModel> fn) {
    setModel(fn(getModel()));
  }

  void resize(Size deviceSize);

  TModel get model => getModel();
}

@immutable
abstract class View<TModel> {
  void render(Canvas c, TModel model);
}
