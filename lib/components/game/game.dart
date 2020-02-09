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
import 'package:ufo_2d/types/typedefs.dart';

void noop() {}

class Game extends BaseGame with VerticalDragDetector, HorizontalDragDetector {
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
      rotation: 0.0,
    );

    final playerController = PlayerController(
      getModel: getPlayerModel,
      setModel: setPlayerModel,
      model: playerModel,
    );

    final staticModels = _staticModels(level.items);

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
        statics: staticModels,
      ),
    );

    final player = Player(playerController);

    _controller = GameController();

    this.add(Background());
    _statics(staticModels).forEach(this.add);
    this.add(player);

    final p = getPlayerModel().rect;
    this.camera =
        Position(p.left, p.top).minus(Position(deviceSize.width / 2, 0));
  }

  GameModel get model => GameModel.instance;

  PlayerModel getPlayerModel() {
    return model.player;
  }

  void setPlayerModel(PlayerModel player) {
    GameModel.set(model.copyWith(player: player));
  }

  GetModel<StaticModel> getStaticModel(int idx) {
    return () => model.statics[idx];
  }

  SetModel<StaticModel> setStaticModel(int idx) {
    return (StaticModel staticModel) {
      final statics = model.statics.toList();
      statics[idx] = staticModel;
      GameModel.set(model.copyWith(statics: statics));
    };
  }

  List<StaticModel> _staticModels(List<GameItem> items) {
    final Iterable<GameItem> staticItems = items.where((x) => x.isStatic);
    return staticItems
        .map(
          (x) => StaticModel(rect: x.rect, item: x),
        )
        .toList();
  }

  List<StaticComponent> _statics(
    List<StaticModel> models,
  ) {
    final statics = List<Static>();
    for (int i = 0; i < models.length; i++) {
      final view = viewForStaticModel(models[i]);
      statics.add(
        Static(
          getStaticModel(i),
          setStaticModel(i),
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

  void onVerticalDragEnd(DragEndDetails details) {
    GameGestures.instance.onVerticalDragEnd(details);
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    GameGestures.instance.onHorizontalDragEnd(details);
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    GameGestures.instance.onVerticalDragUpdate(details);
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    GameGestures.instance.onHorizontalDragUpdate(details);
  }
}
