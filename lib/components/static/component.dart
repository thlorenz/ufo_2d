import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/base.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

@immutable
class StaticModel {
  final Rect rect;
  final GameItem item;
  const StaticModel({@required this.rect, @required this.item});

  StaticModel copyWith({Rect rect}) {
    return StaticModel(rect: rect ?? this.rect, item: this.item);
  }

  String toString() {
    return '''StaticModel {
    rect: $rect
    item: $item
  }''';
  }
}

class Static extends StaticComponent<StaticModel, View<StaticModel>> {
  Static(GetModel<StaticModel> getModel, SetModel<StaticModel> setModel,
      GetTileSize getTileSize, View<StaticModel> view)
      : super(
            getModel: getModel,
            setModel: setModel,
            getTileSize: getTileSize,
            view: view);

  StaticModel init(Size gameSize, GameItem item) => StaticModel(
        rect: _getRect(gameSize, item),
        item: item,
      );

  void resize(Size gameSize) {
    final m = getModel();
    setModel(
      m.copyWith(rect: _getRect(gameSize, m.item)),
    );
  }

  Rect _getRect(Size gameSize, GameItem item) {
    final tileSize = getTileSize(gameSize);
    return rectFromItem(tileSize, item, 3);
  }
}
