import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/physics/vector.dart';
import 'package:ufo_2d/sprites/bullet.dart';

class PlayerActions {
  final double minTimeBetweenShots;
  double _timeSinceLastShot;

  PlayerActions({this.minTimeBetweenShots})
      : _timeSinceLastShot = minTimeBetweenShots;

  Bullet fireShot(PlayerModel player, double dt) {
    _timeSinceLastShot += dt;
    if (_timeSinceLastShot < minTimeBetweenShots) return null;
    _timeSinceLastShot = 0.0;

    final gunPoint = Vector(
      GameProps.playerGunpointDistance,
      0,
    ).rotateTo(player.angle);
    final center =
        player.worldPosition.toOffset().translate(gunPoint.x, gunPoint.y);

    // TODO: player velocity not properly applied
    // player can shoot when moving forward very fast and bullet sticks with it
    final pv = player.velocity;
    final velocity = Vector(GameProps.playerBulletVelocityMagnitude, 0)
        .rotateTo(player.angle)
        .translate(pv.x, pv.y);

    return Bullet(
      center: center,
      velocity: velocity,
      durationMs: 4000,
      radius: 3,
    );
  }
}
