import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ufo_2d/sprites/score_sprite.dart';
import 'package:ufo_2d/sprites/text_sprite.dart';
import 'package:ufo_2d/types.dart';

abstract class Dynamic {
  bool done();
  void update(double dt);
  void render(Canvas canvas);
  Dynamic replaceWith();
}

class Dynamics {
  final _dynamics = List<Dynamic>();

  void update(double dt) {
    final remove = List<Dynamic>();
    for (final sprite in _dynamics) {
      sprite.update(dt);
      if (sprite.done()) remove.add(sprite);
    }
    for (final sprite in remove) {
      _dynamics.remove(sprite);
      final replacement = sprite.replaceWith();
      if (replacement != null) _dynamics.add(replacement);
    }
  }

  void render(Canvas canvas) {
    for (final sprite in _dynamics) {
      sprite.render(canvas);
    }
  }

  void add(Dynamic dynamic) {
    _dynamics.add(dynamic);
  }

  void addScore(TilePosition tile, int score) {
    final style = TextSprite.defaultTextStyle.copyWith(
      color: Colors.amber,
    );
    final wp = WorldPosition.fromTilePosition(tile);
    final center = Offset(wp.x, wp.y);
    final sprite = ScoreSprite(
      score,
      center,
      style: style,
      durationMs: 600,
      angle: pi / 8,
      rotateBy: -pi / 8,
      translateBy: Offset(50, 300),
      scaleTo: Offset(2, 2),
      fadeBy: 0.4,
    );
    add(sprite);
  }
}
