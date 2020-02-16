import 'package:ufo_2d/components/pickup/pickup_model.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/components/wall/wall_model.dart';
import 'package:ufo_2d/controllers/collissions/player_pickup.dart';
import 'package:ufo_2d/controllers/collissions/player_wall.dart';
import 'package:ufo_2d/types/interfaces.dart';
import 'package:ufo_2d/types/typedefs.dart';

enum CollissionEdge { Top, Left, Right, Bottom, Stuck }

class PlayerCollissionController extends Updater {
  final GetModel<PlayerModel> _getPlayerModel;
  final GetModels<WallModel> _getWallModels;
  final GetModels<PickupModel> _getPickupModels;
  final PlayerWallCollission _playerWallCollission;
  final PlayerPickupCollission _playerPickupCollission;

  PlayerCollissionController(
    this._getPlayerModel,
    this._getWallModels,
    this._getPickupModels,
    this._playerWallCollission,
    this._playerPickupCollission,
  );

  void update(double dt) {
    final player = this._getPlayerModel();
    final walls = this._getWallModels();
    final pickups = this._getPickupModels();
    this._playerWallCollission.update(player, walls, dt);
    this._playerPickupCollission.update(player, pickups, dt);
  }
}
