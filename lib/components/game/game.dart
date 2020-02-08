import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:ufo_2d/components/background/background.dart';
import 'package:ufo_2d/components/game/game_controller.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/player/player.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/static/component.dart';
import 'package:ufo_2d/components/static/views.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/base.dart';
import 'package:ufo_2d/types/typedefs.dart';

void noop() {}

class Game extends BaseGame {
  final GameController _controller;
  Game() : _controller = GameController();

  GameModel get model => GameModel.instance;

  Size getTileSize(Size deviceSize, GameLevel level) {
    final tileWidth = 40.0;
    return Size(tileWidth, tileWidth);
  }

  PlayerModel getPlayerModel() {
    return model.player;
  }

  void setPlayerModel(PlayerModel player) {
    GameModel.update(model.copyWith(player: player));
  }

  GetModel<StaticModel> getStaticModel(int idx) {
    return () => model.statics[idx];
  }

  SetModel<StaticModel> setStaticModel(int idx) {
    return (StaticModel staticModel) {
      final statics = model.statics.toList();
      statics[idx] = staticModel;
      GameModel.update(model.copyWith(statics: statics));
    };
  }

  void init(GameLevel level, Size deviceSize) {
    final getTileSize =
        (Size deviceSize) => this.getTileSize(deviceSize, level);

    final tileSize = getTileSize(deviceSize);
    final player = Player(getPlayerModel, setPlayerModel, getTileSize);
    final playerModel = player.init(tileSize, level.player);

    final items = level.items;
    final staticModels = _staticModels(items);
    final gameModel = _controller.init(
      level,
      deviceSize,
      tileSize,
      playerModel,
      staticModels,
    );

    GameModel.init(gameModel);

    this.add(Background(getTileSize));
    _statics(staticModels, getTileSize).forEach(this.add);
    this.add(player);

    final p = playerModel.rect;
    this.camera =
        Position(p.left, p.top).minus(Position(deviceSize.width / 2, 0));
  }

  List<StaticModel> _staticModels(List<GameItem> items) {
    final Iterable<GameItem> staticItems = items.where((x) => x.isStatic);
    return staticItems.map((x) => StaticModel(rect: x.rect, item: x)).toList();
  }

  List<StaticComponent> _statics(
    List<StaticModel> models,
    GetTileSize getTileSize,
  ) {
    final statics = List<Static>();
    for (int i = 0; i < models.length; i++) {
      final view = viewForStaticModel(models[i]);
      statics.add(Static(
        getStaticModel(i),
        setStaticModel(i),
        getTileSize,
        view,
      ));
    }
    return statics;
  }

  void update(double dt) {
    final nonzeroDt = dt == 0 ? 0.01 : dt;
    final p = model.player.rect;
    this.camera = Position(p.left, p.top)
        .minus(Position(model.device.width / 2, model.device.height / 2));
    super.update(nonzeroDt);
    GameModel.update(_controller.update(model, nonzeroDt));
  }

  void resize(Size size) {
    super.resize(size);
    GameModel.update(_controller.resize(model, size));
  }
}
