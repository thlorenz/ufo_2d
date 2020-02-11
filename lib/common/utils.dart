import 'dart:ui';

import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/typedefs.dart';

Rect rectFromSize(double left, double top, Size size) =>
    Rect.fromLTWH(left, top, size.width, size.height);

Rect rectFromItem(Size tileSize, GameItem item, double scaleFactor) {
  final w = tileSize.width;
  final h = tileSize.height;
  // TODO: make scaleFactor (relation of width to tileWidth) part of item
  final size = Size(w * scaleFactor, h * scaleFactor);
  final x = (item.rect.left) * w - (w * scaleFactor / 2);
  final y = (item.rect.top) * h - (h * scaleFactor / 2);
  return Rect.fromLTWH(x, y, size.width, size.height);
}

class ListUpdater<TModel> {
  final GetModel<List<TModel>> _getModels;
  final SetModel<List<TModel>> _setModels;

  ListUpdater(this._getModels, this._setModels);

  TModel getModel(int idx) {
    return _getModels()[idx];
  }

  void setModel(int idx, TModel model) {
    final models = _getModels().toList();
    models[idx] = model;
    _setModels(models);
  }
}

class ListItemUpdater<TModel> {
  final ListUpdater<TModel> _listUpdater;
  final int _itemIdx;

  ListItemUpdater(this._listUpdater, this._itemIdx);

  ListItemUpdater.from(
    GetModel<List<TModel>> getModels,
    SetModel<List<TModel>> setModels,
    this._itemIdx,
  ) : _listUpdater = ListUpdater(getModels, setModels);

  TModel getModel() => _listUpdater.getModel(_itemIdx);
  void setModel(TModel model) => _listUpdater.setModel(_itemIdx, model);
  void updateModel(ModelUpdate<TModel> fn) => setModel(fn(getModel()));
}
