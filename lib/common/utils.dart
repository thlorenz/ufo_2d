import 'dart:ui';

Rect rectFromSize(double left, double top, Size size) =>
    Rect.fromLTWH(left, top, size.width, size.height);
