import 'dart:async';
import 'dart:math';

import 'package:canvas_playground/text_score_sprite.dart';
import 'package:canvas_playground/text_sprite.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextScoreSprite _scoreSprite;

  _MyAppState() {
    _scoreSprite = TextScoreSprite(
      200,
      Offset(500, 300),
      style: TextSprite.defaultTextStyle.copyWith(color: Colors.purple),
      duration: Duration(milliseconds: 300),
      translateBy: Offset(50, 200),
      scaleTo: Offset(2, 2),
      angle: pi / 4,
      rotateBy: -pi / 3,
      opacity: 1.0,
      fadeBy: 1.0,
    );
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: CanvasPainter(_scoreSprite),
      ),
    );
  }

  void initState() {
    super.initState();
    Timer.periodic(
      Duration(milliseconds: 1),
      (_) {
        _scoreSprite.update(1);
        setState(() {});
      },
    );
  }
}

class CanvasPainter extends CustomPainter {
  final Paint _gridPaint;
  final Paint _rectPaint;
  final Paint _circlePaint;
  final Paint _playerPaint;
  final Paint _thrustPaint;
  final TextScoreSprite _scoreSprite;

  CanvasPainter(this._scoreSprite)
      : _gridPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.2,
        _rectPaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill,
        _circlePaint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill,
        _playerPaint = Paint()
          ..color = Colors.amber
          ..style = PaintingStyle.fill,
        _thrustPaint = Paint()
          ..color = Colors.black45
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

  void paint(Canvas canvas, Size size) {
    _lowerLeftCanvas(canvas, size.height);
    _drawGrid(canvas, size);
    canvas.save();
    _drawPlayerWithThrust(canvas, Offset(300, 300), pi / 10);
    canvas.restore();
    _drawPlayerScore(canvas);
  }

  void _lowerLeftCanvas(Canvas canvas, double height) {
    canvas.translate(0, height);
    canvas.scale(1, -1);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final delta = 50;
    for (double col = 0.0; col < size.width; col += delta) {
      canvas.drawLine(Offset(col, 0), Offset(col, size.height), _gridPaint);
    }
    for (double row = 0.0; row < size.height; row += delta) {
      canvas.drawLine(Offset(0, row), Offset(size.width, row), _gridPaint);
    }
  }

  _drawPlayerWithThrust(Canvas canvas, Offset center, double angle) {
    final radius = 20.0;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    canvas.scale(5, 5);

    _drawPlayerShip(canvas, radius);
    _drawPlayerGun(canvas, radius);
    _drawPlayerThrust(canvas, radius);

    canvas.restore();
  }

  void _drawPlayerShip(Canvas canvas, double radius) {
    canvas.drawCircle(Offset(0, 0), radius, _playerPaint);
    canvas.drawCircle(Offset(0, 0), 2, _circlePaint);
  }

  void _drawPlayerGun(Canvas canvas, double radius) {
    final gunSize = 16.0;
    final rect = Rect.fromLTWH(radius - gunSize / 2, 0.0, gunSize, 2);
    canvas.drawRect(rect, _rectPaint);
  }

  void _drawPlayerThrust(Canvas canvas, double radius) {
    final width = radius;
    final length = radius * 2;
    final p1 = Offset(-radius, -width / 2);
    final p2 = Offset(-radius, width / 2);
    final p3 = Offset(-radius - length, 0);
    canvas.drawLine(p1, p2, _thrustPaint);
    canvas.drawLine(p2, p3, _thrustPaint);
    canvas.drawLine(p3, p1, _thrustPaint);
  }

  _drawPlayerScore(Canvas canvas) {
    _scoreSprite.render(canvas);
  }

  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
