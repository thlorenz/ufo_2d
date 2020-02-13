import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ufo_2d/levels/level.dart';

enum PlayerEvent { speedChanged }

@immutable
class PlayerModel {
  final Rect rect;
  final Rect hit;
  final Offset speed;
  final double angle;
  final GameItem item;
  final List<PlayerEvent> events;

  const PlayerModel({
    @required this.rect,
    @required this.hit,
    @required this.speed,
    @required this.angle,
    @required this.item,
    @required this.events,
  });

  PlayerModel copyWith({
    Rect rect,
    Rect hit,
    Offset speed,
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
      speed: speed ?? this.speed,
      angle: angle ?? this.angle,
      events: events ?? this.events,
      item: this.item,
    );
  }

  String toString() {
    return '''PlayerModel {
      rect: $rect
      hit: $hit
      speed: $speed
    }''';
  }
}
