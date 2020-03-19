import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/game/pickups/diamonds.dart';
import 'package:ufo_2d/game/pickups/medkits.dart';
import 'package:ufo_2d/game/pickups/pickup.dart';
import 'package:ufo_2d/models/hud_model.dart';
import 'package:ufo_2d/types.dart';

Pickup _pickupCollidingWith(
  TilePosition tilePosition, {
  @required List<TilePosition> diamonds,
  @required List<TilePosition> medkits,
}) {
  for (final d in diamonds) {
    if (d.isSameTileAs(tilePosition)) return Diamond();
  }
  for (final d in medkits) {
    if (d.isSameTileAs(tilePosition)) return Medkit();
  }
  return null;
}

class Pickups {
  final GetModel<Iterable<TilePosition>> getDiamonds;
  final SetModel<List<TilePosition>> setDiamonds;
  final GetModel<Iterable<TilePosition>> getMedkits;
  final SetModel<List<TilePosition>> setMedkits;
  final void Function(TilePosition tile, int score) onScored;
  final Diamonds _diamonds;
  final Medkits _medkits;

  Pickups({
    @required this.getDiamonds,
    @required this.setDiamonds,
    @required this.getMedkits,
    @required this.setMedkits,
    @required this.onScored,
  })  : _diamonds = Diamonds(getDiamonds()),
        _medkits = Medkits(getMedkits());

  HudModel checkForCollissionsAt(
    TilePosition tile,
    HudModel hud,
  ) {
    final diamondTiles = getDiamonds();
    final medkitTiles = getMedkits();
    final pickup = _pickupCollidingWith(
      tile,
      diamonds: diamondTiles,
      medkits: medkitTiles,
    );
    if (pickup == null) return hud;

    if (pickup.type == PickupType.Diamond) {
      final diamonds =
          diamondTiles.where((x) => !x.isSameTileAs(tile)).toList();
      setDiamonds(diamonds);
      _diamonds.update(diamonds);
    } else if (pickup.type == PickupType.Medkit) {
      final medkits = medkitTiles.where((x) => !x.isSameTileAs(tile)).toList();
      setMedkits(medkits);
      _medkits.update(medkits);
    }

    if (pickup.hasScore) {
      onScored(tile, pickup.score);
      return hud.copyWith(score: hud.score + pickup.score);
    } else if (pickup.hasHealth) {
      return hud.copyWith(health: hud.health + pickup.health);
    }
    return hud;
  }

  void render(Canvas canvas) {
    _diamonds.render(canvas);
    _medkits.render(canvas);
  }
}
