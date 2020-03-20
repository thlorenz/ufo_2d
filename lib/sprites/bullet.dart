import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ufo_2d/physics/vector.dart';
import 'package:ufo_2d/sprites/dymamics.dart';

class Bullet implements Dynamic {
  final Offset center;
  final double durationMs;
  final Vector velocity;
  final double radius;

  Paint bulletPaint;

  Offset _currentCenter;
  double _elapsed;

  Bullet({
    @required this.center,
    @required this.velocity,
    @required this.durationMs,
    @required this.radius,
    this.bulletPaint,
  })  : _currentCenter = center,
        _elapsed = 0 {
    this.bulletPaint = bulletPaint ?? defaultBulletPaint;
  }

  bool done() => _elapsed >= durationMs;

  void render(Canvas canvas) {
    if (done()) return;
    canvas.drawCircle(_currentCenter, radius, bulletPaint);
  }

  void update(double dt) {
    _elapsed += dt * 1E3;
    if (done()) return;
    final percent = _elapsed / durationMs;
    _updateCenter(percent);
  }

  void _updateCenter(double percent) {
    final dx = velocity.x * percent;
    final dy = velocity.y * percent;
    _currentCenter = center.translate(dx, dy);
  }

  static Paint get defaultBulletPaint => Paint()
    ..color = Colors.black45
    ..style = PaintingStyle.fill;
}
