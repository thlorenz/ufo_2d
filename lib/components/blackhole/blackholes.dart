import 'dart:ui';

import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/blackhole/blackhole.dart';
import 'package:ufo_2d/components/blackhole/blackhole_model.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/levels/game_item.dart';

double holeScaleFactor(GameItemType holeType) {
  if (holeType == GameItemType.BlackHoleSmall)
    return Config.blackholeSmallScaleFactor;
  if (holeType == GameItemType.BlackHoleMedium)
    return Config.blackholeMediumScaleFactor;
  if (holeType == GameItemType.BlackHoleLarge)
    return Config.blackholeLargeScaleFactor;
  throw new Exception('Not a black hole $holeType');
}

double holeGravity(GameItemType holeType) {
  if (holeType == GameItemType.BlackHoleSmall)
    return Config.blackholeSmallGravity;
  if (holeType == GameItemType.BlackHoleMedium)
    return Config.blackholeMediumGravity;
  if (holeType == GameItemType.BlackHoleLarge)
    return Config.blackholeLargeGravity;
  throw new Exception('Not a black hole $holeType');
}

class Blackholes {
  final List<BlackholeModel> _models;
  List<Blackhole> _components;

  Blackholes(this._models) {
    _components = _initComponents(_models);
  }

  factory Blackholes.fromItems(List<GameItem> gameItems) {
    return Blackholes(_initModels(gameItems));
  }

  List<BlackholeModel> get models => _models;
  List<Blackhole> get components => _components;

  List<Blackhole> _initComponents(List<BlackholeModel> models) {
    final blackholesUpdater = ListUpdater(
      () => GameModel.instance.blackholes,
      (blackholes) =>
          GameModel.set(GameModel.instance.copyWith(blackholes: blackholes)),
    );
    final components = List<Blackhole>();
    for (int i = 0; i < models.length; i++) {
      final updater = ListItemUpdater(blackholesUpdater, i);
      final controller = BlackholeController(
        getModel: updater.getModel,
        setModel: updater.setModel,
        getPlayerModel: GameModel.getPlayer,
        setPlayerModel: GameModel.setPlayer,
      );
      components.add(Blackhole(controller));
    }
    return components;
  }

  static List<BlackholeModel> _initModels(List<GameItem> gameItems) {
    return gameItems
        .where((x) => x.isBlackhole)
        .map((x) => BlackholeModel(
              rect: Rect.zero,
              item: x,
              scaleFactor: holeScaleFactor(x.type),
              gravity: holeGravity(x.type),
            ))
        .toList();
  }
}
