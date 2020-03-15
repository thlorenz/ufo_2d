import 'dart:ui';

import 'package:flutter/material.dart';

class GameProps {
  // Note to self:
  //  player will have size of tile, but that is just the hit area.
  //  we can render the player a bit larger basically such that the hit
  //  area covers a tile exactly.
  // However that only gives us a 1.2 zoom.
  // Making the hit area even smaller than the player is also an option
  static const tileSize = 60.0;
  static const tileCenter = tileSize / 2;
  static const playerHitSize = tileSize * 0.65;

  static const keyboardPlayerSpeedFactor = 10.0;
  static const keyboardPlayerRotationStep = 0.1;

  static Paint canvasFrame = Paint()
    ..color = Colors.grey
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;
  static Paint worldFrame = Paint()
    ..color = Colors.blue
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;

  static int scoreDiamond = 10;

  static bool get debugHitPoints {
    return false;
  }

  static Paint debugHitPointPaint = Paint()
    ..color = Colors.amberAccent
    ..style = PaintingStyle.fill;

  static bool get debugThrust {
    return false;
  }

  static Paint debugThrustPaint = Paint()
    ..color = Colors.black45
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
}
