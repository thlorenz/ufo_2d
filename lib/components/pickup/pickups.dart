import 'dart:ui';

import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/components/pickup/pickup.dart';
import 'package:ufo_2d/components/pickup/pickup_controller.dart';
import 'package:ufo_2d/components/pickup/pickup_model.dart';
import 'package:ufo_2d/levels/game_item.dart';

class Pickups {
  final List<PickupModel> _models;
  List<Pickup> _components;

  Pickups(this._models) {
    _components = _initComponents(_models);
  }

  factory Pickups.fromItems(List<GameItem> gameItems) {
    return Pickups(_initModels(gameItems));
  }

  List<PickupModel> get models => _models;
  List<Pickup> get components => _components;

  List<Pickup> _initComponents(List<PickupModel> models) {
    final pickupsUpdater = ListUpdater(
      () => GameModel.instance.pickups,
      (pickups) => GameModel.set(GameModel.instance.copyWith(pickups: pickups)),
    );
    final components = List<Pickup>();
    for (int i = 0; i < models.length; i++) {
      final model = models[i];
      final updater = ListItemUpdater(pickupsUpdater, i);
      final scaleFactor = model.item.type == GameItemType.Diamond
          ? Config.diamondScaleFactor
          : 1.0;
      final controller = PickupController(
        getModel: updater.getModel,
        setModel: updater.setModel,
        scaleFactor: scaleFactor,
      );
      components.add(Pickup(controller, model.item));
    }
    return components;
  }

  static List<PickupModel> _initModels(List<GameItem> gameItems) {
    return gameItems
        .where((x) => x.isPickup)
        .map((x) => PickupModel(rect: Rect.zero, item: x, pickedUp: false))
        .toList();
  }
}
