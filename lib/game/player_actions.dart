import 'package:ufo_2d/admin/game_props.dart';
import 'package:ufo_2d/models/player_model.dart';
import 'package:ufo_2d/physics/vector.dart';
import 'package:ufo_2d/sprites/bullet.dart';

class PlayerActions {
  static Bullet fireShot(PlayerModel player) {
    final gunPoint = Vector(
      GameProps.playerGunpointDistance,
      0,
    ).rotateTo(player.angle);
    final center =
        player.worldPosition.toOffset().translate(gunPoint.x, gunPoint.y);
    final velocity = Vector(
      GameProps.playerBulletVelocityMagnitude,
      0,
    ).rotateTo(player.angle);
    return Bullet(
      center: center,
      velocity: velocity,
      durationMs: 4000,
      radius: 3,
    );
  }
}
