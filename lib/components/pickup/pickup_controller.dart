import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/pickup/pickup_model.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

class PickupController extends Controller<PickupModel> {
  final double scaleFactor;
  PickupController({
    @required GetModel<PickupModel> getModel,
    @required SetModel<PickupModel> setModel,
    this.scaleFactor,
  }) : super(getModel, setModel);

  void resize(Size deviceSize) {
    final rect = rectFromItem(Config.tileSize, model.item, scaleFactor);
    updateModel((m) => m.copyWith(rect: rect));
  }
}
