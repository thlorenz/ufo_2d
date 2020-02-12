import 'dart:ui';

import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/wall/wall.dart';
import 'package:ufo_2d/components/wall/wall_controller.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/levels/level.dart';

class Walls {
  final List<WallModel> _models;
  List<Wall> _components;

  Walls(this._models) {
    _components = _initComponents(_models);
  }

  factory Walls.fromItems(List<GameItem> gameItems) {
    return Walls(_initModels(gameItems));
  }

  List<WallModel> get models => _models;
  List<Wall> get components => _components;

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

  static List<WallModel> _initModels(List<GameItem> gameItems) {
    return gameItems
        .where((x) => x.isWall)
        .map((x) => WallModel(rect: Rect.zero, item: x))
        .toList();
  }
}
