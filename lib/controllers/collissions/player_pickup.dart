import 'dart:ui';

import 'package:ufo_2d/components/pickup/pickup_model.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/stats/stats_model.dart';
import 'package:ufo_2d/types/typedefs.dart';

class PlayerPickupCollission {
  final UpdateModel<StatsModel> _updateStatsModel;
  final UpdateListModel<PickupModel> _updatePickupModel;
  const PlayerPickupCollission(
    this._updateStatsModel,
    this._updatePickupModel,
  );

  void update(PlayerModel player, List<PickupModel> pickups, double dt) {
    final pickup = _collidingWith(
      pickups.where((x) => !x.pickedUp),
      player.hit,
    );

    if (pickup == null) return;

    _updateStatsModel(
      (m) => m.copyWith(
        score: m.score + pickup.score,
        health: m.health + pickup.health,
      ),
    );
    _updatePickupModel(pickup, () => pickup.copyWith(pickedUp: true));
  }

  PickupModel _collidingWith(
    Iterable<PickupModel> pickups,
    Rect playerHit,
  ) {
    final match = pickups.where((x) => x.rect.overlaps(playerHit));
    return match.length > 0 ? match.first : null;
  }
}
