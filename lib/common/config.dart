import 'dart:ui';

import 'package:flutter/material.dart';

class Config {
  static const bigG = 6.67 * 1E-11;

  static const tileWidth = 60.0;
  static const tileHeight = 60.0;
  static const tileSize = Size(tileWidth, tileHeight);

  static const backgroundTilesRandom = false;
  static const backgroundTileScaleFactor = 1;

  static const playerScaleFactor = 1.5;
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

  static const diamondScaleFactor = 1.0;

  static bool get audioOn {
    return true;
  }

  static double totalHealth = 100;
  static double wallHealthFactor = 0.01;
  static int pickupScoreDiamond = 2;
  static double healthIncBasic = 10.0;

  static double blackholeSmallScaleFactor = 1.0;
  static double blackholeMediumScaleFactor = 1.5;
  static double blackholeLargeScaleFactor = 2.0;
  static double blackholeSmallMass = 8.0 * 1E15;
  static double blackholeMediumMass = blackholeSmallMass * 2;
  static double blackholeLargeMass = blackholeMediumMass * 2;
  static double healthDecBlackhole = -10.0;

  static bool get debugBlackholePull => true;

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
  static Paint debugVector = Paint()
    ..color = Colors.red
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;
}
