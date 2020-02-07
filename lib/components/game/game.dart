import 'dart:ui';

import 'package:flame/game.dart';
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
  final GameLevel _level;
  Game(this._level) : _controller = GameController();

  GameModel get model => GameModel.instance;

  Size getTileSize(Size gameSize) {
    final tileWidth = (gameSize.width / _level.ncols).roundToDouble();
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

  void init(Size gameSize) {
    final player = Player(getPlayerModel, setPlayerModel, getTileSize);
    final playerModel = player.init(gameSize, _level.player);

    final items = _level.items;
    final staticModels = _staticModels(items);
    final gameModel = _controller.init(gameSize, playerModel, staticModels);

    GameModel.init(gameModel);

    this.add(Background());
    _statics(staticModels).forEach(this.add);
    this.add(player);
  }

  List<StaticModel> _staticModels(List<GameItem> items) {
    final Iterable<GameItem> staticItems = items.where((x) => x.isStatic);
    return staticItems.map((x) => StaticModel(rect: x.rect, item: x)).toList();
  }

  List<StaticComponent> _statics(List<StaticModel> models) {
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
    super.update(nonzeroDt);
    GameModel.update(_controller.update(model, nonzeroDt));
  }

  void resize(Size size) {
    super.resize(size);
    GameModel.update(_controller.resize(model, size, getTileSize(size)));
  }
}
