import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/build_model.dart';
import 'package:ufo_2d/models/hud_model.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/types.dart';

@immutable
class GameModel {
  final Tilemap tilemap;
  final List<TilePosition> floorTiles;
  final List<TilePosition> walls;
  final List<TilePosition> diamonds;
  final List<TilePosition> medkits;
  final PlayerModel player;
  final HudModel hud;
  final List<List<bool>> wallTiles;

  GameModel({
    @required this.tilemap,
    @required this.floorTiles,
    @required this.walls,
    @required this.wallTiles,
    @required this.diamonds,
    @required this.medkits,
    @required this.player,
    @required this.hud,
  });

  GameModel copyWith({
    PlayerModel player,
    HudModel hud,
    List<TilePosition> diamonds,
    List<TilePosition> medkits,
  }) {
    return GameModel(
      tilemap: this.tilemap,
      floorTiles: this.floorTiles,
      walls: this.walls,
      wallTiles: this.wallTiles,
      diamonds: diamonds ?? this.diamonds,
      medkits: medkits ?? this.medkits,
      player: player ?? this.player,
      hud: hud ?? this.hud,
    );
  }

  static GameModel _instance;
  static GameModel initFrom(Tilemap tilemap) => _instance = buildModel(tilemap);
  static GetModel<GameModel> getGame = () => _instance;

  // Player
  static GetModel<PlayerModel> getPlayer = () => _instance.player;
  static SetModel<PlayerModel> setPlayer =
      (PlayerModel player) => _instance = _instance.copyWith(player: player);

  // Hud
  static GetModel<HudModel> getHud = () => _instance.hud;
  static SetModel<HudModel> setHud = (HudModel hud) {
    _instance = _instance.copyWith(hud: hud);
    _hudUpdate$.add(hud);
  };
  static Subject<HudModel> _hudUpdate$ = PublishSubject();
  static Stream<HudModel> get hudUpdate$ {
    return _hudUpdate$;
  }

  // Walls
  static GetModel<List<List<bool>>> getWallTiles = () => _instance.wallTiles;

  // Diamonds
  static GetModel<Iterable<TilePosition>> getDiamonds =
      () => _instance.diamonds;
  static SetModel<List<TilePosition>> setDiamonds =
      (List<TilePosition> diamonds) =>
          _instance = _instance.copyWith(diamonds: diamonds);

  // Medkits
  static GetModel<Iterable<TilePosition>> getMedkits = () => _instance.medkits;
  static SetModel<List<TilePosition>> setMedkits =
      (List<TilePosition> medkits) =>
          _instance = _instance.copyWith(medkits: medkits);
}
