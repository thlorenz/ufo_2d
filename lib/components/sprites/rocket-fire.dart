import 'dart:math';
import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/types/typedefs.dart';

class RocketFireComponent extends AnimationComponent {
  final GetModel<PlayerModel> getPlayerModel;
  RocketFireComponent._(
      this.getPlayerModel, double width, double height, Animation animation)
      : super(width, height, animation) {
    destroyOnFinish = true;
  }
  void update(double dt) {
    final m = getPlayerModel();
    final p = m.rect;

    final r = m.hit.width / 2;
    final x = p.left + (r * cos(m.angle));
    final y = p.top + (r * sin(m.angle));
    setByRect(Rect.fromLTWH(
      x,
      y,
      p.width / 2,
      p.height / 2,
    ));
    angle = m.angle;
    super.update(dt);
  }
}

const columns = 50;
const int width = 7700 ~/ columns;
const height = 442;

class RocketFire {
  final SpriteSheet spriteSheet;
  final GetModel<PlayerModel> getPlayerModel;
  RocketFire(this.getPlayerModel)
      : spriteSheet = SpriteSheet(
          imageName: 'sprites/rocket-fire.png',
          textureWidth: width,
          textureHeight: height,
          columns: columns,
          rows: 1,
        );

  RocketFireComponent get component {
    final animation = spriteSheet.createAnimation(
      0,
      stepTime: 0.015,
      from: 0,
      to: columns,
      loop: false,
    );
    return RocketFireComponent._(
      this.getPlayerModel,
      width.toDouble(),
      height.toDouble(),
      animation,
    );
  }
}
