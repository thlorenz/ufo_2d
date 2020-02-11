import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/wall/wall.dart';
import 'package:ufo_2d/components/wall/wall_controller.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/levels/level.dart';

class Walls {
  List<WallModel> _models;
  List<Wall> _components;

  Walls(List<GameItem> gameItems) {
    _models = _initModels(gameItems);
    _components = _initComponents(_models);
  }

  List<WallModel> get models => _models;
  List<Wall> get components => _components;

  List<WallModel> _initModels(List<GameItem> gameItems) {
    return gameItems
        .where((x) => x.isWall)
        .map((x) => WallModel(rect: Rect.zero, item: x))
        .toList();
  }

  List<Wall> _initComponents(List<WallModel> models) {
    final wallsUpdater = ListUpdater(
      () => GameModel.instance.walls,
      (walls) => GameModel.set(GameModel.instance.copyWith(walls: walls)),
    );
    final components = List<Wall>();
    for (int i = 0; i < models.length; i++) {
      final updater = ListItemUpdater(wallsUpdater, i);
      final controller = WallController(
        getModel: updater.getModel,
        setModel: updater.setModel,
      );
      components.add(Wall(controller));
    }
    return components;
  }
}
