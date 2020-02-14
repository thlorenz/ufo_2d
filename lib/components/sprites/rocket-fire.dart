import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/position.dart';
import 'package:flame/spritesheet.dart';
import 'package:ufo_2d/common/utils.dart';
import 'package:ufo_2d/components/player/player_model.dart';
import 'package:ufo_2d/types/typedefs.dart';

class RocketFireComponent extends AnimationComponent {
  final GetModel<PlayerModel> getPlayerModel;
  RocketFireComponent._(
      this.getPlayerModel, double width, double height, Animation animation)
      : super(width, height, animation) {
    destroyOnFinish = true;
    anchor = Anchor.center;
  }
  void update(double dt) {
    final m = getPlayerModel();
    angle = m.angle;

    final r = m.hit.width * 0.8;
    final p = pointOnCircle(m.angle + pi / 2, r);
    setByPosition(Position.fromOffset(m.hit.center.translate(p.x, p.y)));
    super.update(dt);
  }

  void resize(Size size) {
    final m = getPlayerModel();
    setBySize(Position(m.rect.width * 0.8, m.rect.height * 0.8));
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
      stepTime: 0.012,
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
