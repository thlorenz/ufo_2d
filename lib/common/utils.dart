import 'dart:ui';

import 'package:ufo_2d/levels/level.dart';

Rect rectFromSize(double left, double top, Size size) =>
    Rect.fromLTWH(left, top, size.width, size.height);

Rect rectFromItem(Size tileSize, GameItem item, int scaleFactor) {
  final w = tileSize.width;
  final h = tileSize.height;
  final size = Size(w * scaleFactor, h * scaleFactor);
  final x = item.rect.left * w;
  final y = item.rect.top * h;
  return Rect.fromLTWH(x, y, size.width, size.height);
}
