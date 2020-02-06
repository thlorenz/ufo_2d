import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
abstract class Controller<TModel> {
  TModel resize(TModel model, Size gameSize);
  TModel update(TModel model, double dt);
}

@immutable
abstract class View<TModel> {
  void render(Canvas c, TModel model);
}
