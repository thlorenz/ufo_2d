import 'dart:ui';

import 'package:flutter/material.dart';

class Config {
  static const tileWidth = 45.0;
  static const tileHeight = 45.0;
  static const tileSize = Size(tileWidth, tileHeight);

  static const playerScaleFactor = 2.4;
  static const playerSpeedFactor = 0.3;
  static const playerAngleFactor = 0.006;
  static const playerHitRatio = 0.1;
  static const playerHitWallSlowdown = 0.7;

  static const wallScaleFactor = 1.0;

  static const diamondScaleFactor = 1.4;

  static bool debugRenderPlayer = false;
  static Paint debugRectPaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;
  static Paint debugHitPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;
}
