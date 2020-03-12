import 'dart:ui';

import 'package:flutter/material.dart';

class GameProps {
  // Note to self:
  //  player will have size of tile, but that is just the hit area.
  //  we can render the player a bit larger basically such that the hit
  //  area covers a tile exactly.
  // However that only gives us a 1.2 zoom.
  // Making the hit area even smaller thatn the player is also an option
  static const tileSize = 26.0;
  static const tileCenter = tileSize / 2;

  static const keyboardPlayerSpeedFactor = 10.0;

  static Paint canvasFrame = Paint()
    ..color = Colors.grey
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;
  static Paint worldFrame = Paint()
    ..color = Colors.blue
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;
}
