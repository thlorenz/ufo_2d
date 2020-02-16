import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:ufo_2d/components/pickup/pickup_model.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/stats/stats_model.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/levels/level.dart';
import 'package:ufo_2d/types/typedefs.dart';

@immutable
class GameModel {
  final PlayerModel player;
  final StatsModel stats;
  final Rect rect;
  final Rect device;
  final GameLevel level;
  final List<PickupModel> pickups;
  final List<WallModel> walls;

  const GameModel({
    @required this.player,
    @required this.stats,
    @required this.rect,
    @required this.level,
    @required this.device,
    @required this.pickups,
    @required this.walls,
  });

  GameModel copyWith({
    PlayerModel player,
    StatsModel stats,
    Rect rect,
    Rect device,
    List<PickupModel> pickups,
    List<WallModel> walls,
  }) =>
      GameModel(
        level: this.level,
        player: player ?? this.player,
        stats: stats ?? this.stats,
        rect: rect ?? this.rect,
        device: device ?? this.device,
        pickups: pickups ?? this.pickups,
        walls: walls ?? this.walls,
      );

  String toString() {
    return '''GameModel {
      player: $player
      stats: $stats
      device: $device
      rect: $rect
      statics: $pickups
      walls: $walls
    }''';
  }

  static Subject<StatsModel> _statsUpdate$ = PublishSubject();
  static Stream<StatsModel> get statsUpdate$ {
    return _statsUpdate$;
  }

  static GameModel _instance;
  static GameModel get instance => _instance;
  static void set(GameModel model) {
    _instance = model;
  }

  static PlayerModel getPlayer() => instance.player;
  static void setPlayer(PlayerModel player) =>
      GameModel.set(instance.copyWith(player: player));
  static void updatePlayer(ModelUpdate<PlayerModel> fn) {
    setPlayer(fn(getPlayer()));
  }

  static StatsModel getStats() => instance.stats;
  static void setStats(StatsModel stats) {
    GameModel.set(instance.copyWith(stats: stats));
    _statsUpdate$.add(stats);
  }

  static void updateStats(ModelUpdate<StatsModel> fn) {
    setStats(fn(getStats()));
  }

  static List<WallModel> getWalls() => instance.walls;

  static List<PickupModel> getPickups() => instance.pickups;
  static void setPickups(List<PickupModel> pickups) {
    GameModel.set(instance.copyWith(pickups: pickups));
  }

  static void updatePickups(ModelUpdate<List<PickupModel>> fn) {
    setPickups(fn(getPickups()));
  }

  static void updatePickup(PickupModel pickup, PickupModel Function() fn) {
    final pickups = getPickups();
    final idx = pickups.indexOf(pickup);
    if (idx < 0) throw new Exception('$pickup not found in $pickups');

    final updatedPickup = fn();
    final updatedPickups = List<PickupModel>.from(pickups)
      ..removeAt(idx)
      ..insert(idx, updatedPickup);
    setPickups(updatedPickups);
  }

  static void dispose() {
    _instance = null;
    _statsUpdate$?.close();
    _statsUpdate$ = new PublishSubject();
  }
}
