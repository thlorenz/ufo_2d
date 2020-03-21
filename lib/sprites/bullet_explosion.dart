import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/foundation.dart';
import 'package:ufo_2d/sprites/dymamics.dart';

const _cols = 4;
const _rows = 4;
const int _width = 256 ~/ _cols;
const int _height = 256 ~/ _rows;
final _spriteSheet = SpriteSheet(
  imageName: 'sprites/explosion.png',
  textureWidth: _width,
  textureHeight: _height,
  columns: _cols,
  rows: _rows,
);

Animation _createAnimation(
  SpriteSheet spriteSheet, {
  @required double stepTime,
  @required int rowTo,
  @required int colTo,
  int rowFrom = 0,
  int colFrom = 0,
  bool loop = true,
}) {
  final animatedSprites = List<Sprite>();
  for (int r = rowFrom; r < rowTo; r++) {
    for (int c = colFrom; c < colTo; c++) {
      animatedSprites.add(spriteSheet.getSprite(r, c));
    }
  }

  return Animation.spriteList(
    animatedSprites,
    stepTime: stepTime,
    loop: loop,
  );
}

class BulletExplosion extends Dynamic {
  final Animation _animation;
  final Position center;
  final double radius;
  BulletExplosion(this.center, this.radius)
      : _animation = _createAnimation(
          _spriteSheet,
          stepTime: 0.02,
          rowTo: _rows,
          colTo: _cols,
          loop: false,
        );

  bool done() => _animation.done();

  void update(double dt) {
    _animation.update(dt);
  }

  void render(Canvas canvas) {
    _animation.getSprite().renderCentered(
          canvas,
          center,
          size: Position(radius, radius),
        );
  }

  Dynamic replaceWith() => null;
}
