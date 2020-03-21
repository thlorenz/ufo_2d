import 'dart:math' show Point, atan2, acos, cos, sin, pi, sqrt;
import 'dart:ui' show hashValues;

import 'package:flutter/foundation.dart';

// https://www.mathsisfun.com/algebra/vectors.html

const double _RAD_TO_DEG = 180 / pi;

@immutable
class Vector {
  final double x;
  final double y;

  const Vector(this.x, this.y);

  double get magnitudeSquared => x * x + y * y;
  double get magnitude => sqrt(magnitudeSquared);

  double get angle => atan2(y, x);
  double get angleDeg => angle * _RAD_TO_DEG;

  Vector get reversed => Vector(-x, -y);
  Vector get normalized => Vector(x / magnitude, y / magnitude);

  double angleFrom(Vector other) => (x == 0 && y == 0)
      ? other.angle
      : other.x == 0 && other.y == 0
          ? angle
          : acos(dotProduct(other) / (magnitude * other.magnitude));

  Vector scale(double scaleX, double scaleY) => Vector(x * scaleX, y * scaleY);

  Vector translate(double tx, double ty) => Vector(x + tx, y + ty);
  Vector translateX(double tx) => translate(tx, 0);
  Vector translateY(double ty) => translate(0, ty);

  // https://www.mathsisfun.com/algebra/vectors-dot-product.html
  double dotProduct(Vector other) => x * other.x + y * other.y;

  Vector rotateTo(double angle) {
    final double nx = cos(angle) * x - sin(angle) * y;
    final double ny = sin(angle) * x + cos(angle) * y;
    return Vector(nx, ny);
  }

  Vector rotateToDeg(double angle) => rotateTo(angle * _RAD_TO_DEG);
  Vector rotateBy(double radians) => rotateTo(angle + radians);

  //
  // operator overloads
  //
  Vector operator -() => Vector(-x, -y);

  Vector operator -(Vector other) => Vector(x - other.x, y - other.y);
  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);

  Vector operator *(double operand) => Vector(x * operand, y * operand);
  Vector operator /(double operand) => Vector(x / operand, y / operand);

  //
  // equality and toString
  //
  int get hashCode => hashValues(x, y);
  bool operator ==(dynamic other) {
    return other is Vector && other.x == x && other.y == y;
  }

  String toString() => '''Vector {
   x: ${x.toStringAsFixed(2)}
   y: ${y.toStringAsFixed(2)}
   magnitude: ${magnitude.toStringAsFixed(2)}
   angle: ${angleDeg.toStringAsFixed(2)}
}
''';

  //
  // statics
  //
  static const Vector zero = Vector(0.0, 0.0);

  /// Returns vector from p1 to p2
  static Vector fromPoints(Point p1, Point p2) =>
      Vector(p2.x - p1.x, p2.y - p1.y);
}
