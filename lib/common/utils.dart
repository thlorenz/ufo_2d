import 'dart:ui';

import 'package:ufo_2d/levels/level.dart';

Rect rectFromSize(double left, double top, Size size) =>
    Rect.fromLTWH(left, top, size.width, size.height);

Rect rectFromItem(Size tileSize, GameItem item, int scaleFactor) {
  final w = tileSize.width;
  final h = tileSize.height;
  // TODO: make scaleFactor (relation of width to tileWidth) part of item
  final size = Size(w * scaleFactor, h * scaleFactor);
  final x = (item.rect.left) * w - (w * scaleFactor / 2);
  final y = (item.rect.top) * h - (h * scaleFactor / 2);
  return Rect.fromLTWH(x, y, size.width, size.height);
}
