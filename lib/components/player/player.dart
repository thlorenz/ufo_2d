import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:ufo_2d/components/player/player_controller.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/player/player_view.dart';
import 'package:ufo_2d/inputs/gestures.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/base.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

class Player extends DynamicComponent<PlayerModel, PlayerController, PlayerView>
    implements IDisposable {
  StreamSubscription<DragEndDetails> _horizontalDragSub;
  Player(
    GetModel<PlayerModel> getModel,
    SetModel<PlayerModel> setModel,
    GetTileSize getTileSize,
  ) : super(
          getModel: getModel,
          setModel: setModel,
          controller: PlayerController(),
          view: PlayerView(),
          getTileSize: getTileSize,
        );

  PlayerModel init(Size tileSize, GameItem item) {
    _horizontalDragSub = GameGestures.instance.horizontalDrag$
        .listen((details) => _rotate(details.velocity.pixelsPerSecond.dx));

    return controller.init(tileSize, item);
  }

  void _rotate(double dr) {
    debugPrint('rotating $dr');

    setModel(controller.rotate(getModel(), dr));
  }

  void dispose() {
    _horizontalDragSub?.cancel();
  }
}
