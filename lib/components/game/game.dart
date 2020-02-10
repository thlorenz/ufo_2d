import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/background/background.dart';
import 'package:ufo_2d/components/game/game_controller.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/player/player.dart';
import 'package:ufo_2d/components/player/player_controller.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/static/component.dart';
import 'package:ufo_2d/components/static/views.dart';
import 'package:ufo_2d/inputs/gestures.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/base.dart';

void noop() {}

class Game extends BaseGame with PanDetector {
  GameController _controller;

  Game(GameLevel level, Size deviceSize) {
    final rect = rectFromItem(
      Config.tileSize,
      level.player,
      Config.playerScaleFactor,
    );

    final playerModel = PlayerModel(
      rect: rect,
      speed: Offset(0, 0),
      item: level.player,
      angle: 0.0,
    );

    final playerController = PlayerController(
      getModel: () => model.player,
      setModel: (player) => GameModel.set(model.copyWith(player: player)),
    );

    final pickups = _pickups(level.items);

    GameModel.set(
      GameModel(
        device: rectFromSize(0, 0, deviceSize),
        level: level,
        rect: rectFromSize(
            0,
            0,
            Size(
              level.ncols * Config.tileSize.width,
              level.nrows * Config.tileSize.height,
            )),
        player: playerModel,
        statics: pickups,
      ),
    );

    final player = Player(playerController);

    _controller = GameController();

    this.add(Background());
    _statics(pickups).forEach(this.add);
    this.add(player);

    final p = model.player.rect;
    this.camera =
        Position(p.left, p.top).minus(Position(deviceSize.width / 2, 0));
  }

  GameModel get model => GameModel.instance;

  List<StaticModel> _pickups(List<GameItem> items) {
    final Iterable<GameItem> pickups = items.where((x) => x.isPickup);
    return pickups
        .map(
          (x) => StaticModel(rect: x.rect, item: x),
        )
        .toList();
  }

  List<StaticComponent> _statics(
    List<StaticModel> models,
  ) {
    final staticsUpdater = ListUpdater(
      () => GameModel.instance.statics,
      (statics) => GameModel.set(GameModel.instance.copyWith(statics: statics)),
    );

    final statics = List<Static>();
    for (int i = 0; i < models.length; i++) {
      final view = viewForStaticModel(models[i]);
      final itemUpdater = ListItemUpdater(staticsUpdater, i);
      statics.add(
        Static(
          itemUpdater.getModel,
          itemUpdater.setModel,
          view,
        ),
      );
    }
    return statics;
  }

  void update(double dt) {
    final nonzeroDt = dt == 0 ? 0.01 : dt;
    final p = model.player.rect;
    this.camera = Position(p.left, p.top)
        .minus(Position(model.device.width / 2, model.device.height / 2));
    super.update(nonzeroDt);
    _controller.update(nonzeroDt);
  }

  void resize(Size size) {
    super.resize(size);
    _controller.resize(size);
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    GameGestures.instance.onPanUpdate(details);
  }

  void onPanEnd(DragEndDetails details) {
    GameGestures.instance.onPanEnd(details);
  }
}
