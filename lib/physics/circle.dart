import 'dart:math';

Point pointOnCircle(double rad, double radius) {
  return Point(radius * cos(rad), radius * sin(rad));
}
