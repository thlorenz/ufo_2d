import 'dart:ui';

typedef GetModel<TModel> = TModel Function();
typedef SetModel<TModel> = void Function(TModel);
typedef UpdateModel<TModel> = TModel Function(TModel);
typedef GetTileSize = Size Function(Size);
