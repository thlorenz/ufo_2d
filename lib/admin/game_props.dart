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

  static const gesturePlayerRotationFactor = 0.04;
  static const gesturePlayerThrustFactor = 0.04;
  static const gesturePlayerMinThrustDelta = 2.2;
  static const gesturePlayerMinShotDelta = 2.2;
  static const gestureMinTimeBetweenShotsSec = 0.04;
  static const keyboardPlayerSpeedFactor = 10.0;
  static const keyboardPlayerRotationStep = 0.1;
  static const keyboardMinTimeBetweenShotsSec = 0.08;

  static const playerTotalHealth = 100.0;
  static const playerHitsWallHealthFactor = 0.5;
  static const playerHitsWallSlowdown = 0.7;
  static const playerBulletVelocityMagnitude = 2000.0;
  static const playerGunpointDistance = 30.0;

  static Paint canvasFrame = Paint()
    ..color = Colors.grey
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;
  static Paint worldFrame = Paint()
    ..color = Colors.blue
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;

  static int scoreDiamond = 10;
  static double healthMedkit = 10;

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

  static bool get debugCanvasFrame => false;
  static bool get audioOn => false;
}
