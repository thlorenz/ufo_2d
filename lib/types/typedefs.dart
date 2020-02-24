import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class Tuple<T, U> {
  final T first;
  final U second;
  const Tuple(this.first, this.second);
}


typedef GetModel<TModel> = TModel Function();
typedef GetModels<TModel> = List<TModel> Function();
typedef GetModelByIdx<TModel> = TModel Function(int idx);
typedef SetModel<TModel> = void Function(TModel);
typedef SetModelByIdx<TModel> = void Function(int idx, TModel);
typedef ModelUpdate<TModel> = TModel Function(TModel);
typedef UpdateModel<TModel> = void Function(ModelUpdate<TModel> fn);
typedef UpdateListModel<TModel> = void Function(
  TModel item,
  TModel Function() fn,
);
typedef GetTileSize = Size Function(Size);
