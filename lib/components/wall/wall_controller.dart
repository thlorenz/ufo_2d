import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

class WallController extends Controller<WallModel> {
  WallController({
    @required GetModel<WallModel> getModel,
    @required SetModel<WallModel> setModel,
    @required WallModel model,
  }) : super(getModel, setModel);

  void resize(Size deviceSize) {
    final rect = rectFromItem(
      Config.tileSize,
      model.item,
      Config.playerScaleFactor,
    );
    updateModel((m) => m.copyWith(rect: rect));
  }
}
