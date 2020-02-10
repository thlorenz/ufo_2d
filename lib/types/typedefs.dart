import 'dart:ui';

typedef GetModel<TModel> = TModel Function();
typedef GetModelByIdx<TModel> = TModel Function(int idx);
typedef SetModel<TModel> = void Function(TModel);
typedef SetModelByIdx<TModel> = void Function(int idx, TModel);
typedef UpdateModel<TModel> = TModel Function(TModel);
typedef GetTileSize = Size Function(Size);
