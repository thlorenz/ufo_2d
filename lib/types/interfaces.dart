import 'dart:ui';

import 'package:flutter/foundation.dart';

abstract class IDisposable {
  void dispose();
}

@immutable
abstract class Controller<TModel> {
  TModel resize(TModel model, Size deviceSize);
  TModel update(TModel model, double dt);
}

@immutable
abstract class View<TModel> {
  void render(Canvas c, TModel model);
}
