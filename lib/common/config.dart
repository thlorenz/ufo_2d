import 'dart:ui';

import 'package:flutter/material.dart';

class Config {
  static const tileWidth = 30.0;
  static const tileHeight = 30.0;
  static const tileSize = Size(tileWidth, tileHeight);
  static const backgroundTilesRandom = false;

  static const playerScaleFactor = 2.4;
  static const playerHitRatio = 0.1;
  static const playerHitWallSlowdown = 0.7;
  static const playerMaxSpeed = 1E6;

  static bool get playerAcceleratesBackward {
    return false;
  }

  static const gesturePlayerRotationFactor = 0.04;
  static const gesturePlayerSpeedFactor = 1.0;
  static const keyboardPlayerRotationStep = 0.1;
  static const keyboardPlayerSpeedFactor = 40.0;

  static const wallScaleFactor = 1.0;

  static const diamondScaleFactor = 1.4;

  static bool get audioOn {
    return true;
  }

  static bool get debugRenderPlayer {
    return false;
  }

  static Paint debugRectPaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;
  static Paint debugHitPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;
  static Paint debugCenterPaint = Paint()
    ..color = Colors.amberAccent
    ..style = PaintingStyle.fill;
  static Paint debugGunPaint = Paint()
    ..color = Colors.deepPurple
    ..style = PaintingStyle.fill;
}
