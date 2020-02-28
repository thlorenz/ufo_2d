import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/game_item.dart';
import 'package:ufo_2d/physics/vector.dart';

enum PlayerEvent { speedChanged }

@immutable
class PlayerModel {
  final Rect rect;
  final Rect hit;
  final Vector velocity;
  final double angle;
  final GameItem item;
  final List<PlayerEvent> events;

  const PlayerModel({
    @required this.rect,
    @required this.hit,
    @required this.velocity,
    @required this.angle,
    @required this.item,
    @required this.events,
  });

  Offset get hitTop => hit.topCenter;
  Offset get hitLeft => hit.centerLeft;
  Offset get hitBottom => hit.bottomCenter;
  Offset get hitRight => hit.centerRight;

  PlayerModel copyWith({
    Rect rect,
    Rect hit,
    Vector velocity,
    double angle,
    PlayerEvent event,
  }) {
    List<PlayerEvent> events;
    if (event != null) {
      events = List.from(this.events);
      events.add(event);
    }
    return PlayerModel(
      rect: rect ?? this.rect,
      hit: hit ?? this.hit,
      velocity: velocity ?? this.velocity,
      angle: angle ?? this.angle,
      events: events ?? this.events,
      item: this.item,
    );
  }

  String toString() {
    return '''PlayerModel {
      rect: $rect
      hit: $hit
      speed: $velocity
      angle: $angle
    }''';
  }
}
