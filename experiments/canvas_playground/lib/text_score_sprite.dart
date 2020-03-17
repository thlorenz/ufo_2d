import 'dart:ui' show Canvas, Offset;

import 'package:canvas_playground/text_sprite.dart';
import 'package:flutter/painting.dart' show TextStyle;

class TextScoreSprite {
  final double score;
  final Offset scale;
  final Offset center;
  final Offset translateBy;
  final double rotateBy;
  final Duration duration;
  final double angle;
  final double opacity;
  final double fadeBy;

  TextSprite _sprite;

  Offset _currentCenter;
  Offset _currentScale;
  double _currentAngle;
  double _currentOpacity;

  double _scaleX;
  double _scaleY;
  double _elapsed;

  TextScoreSprite(
    this.score,
    this.center, {
    this.scale = const Offset(1, 1),
    Offset scaleTo = const Offset(1, 1),
    this.translateBy = Offset.zero,
    this.duration = const Duration(milliseconds: 200),
    this.angle = 0,
    this.rotateBy = 0.0,
    this.opacity = 1.0,
    this.fadeBy = 0.0,
    TextStyle style = TextSprite.defaultTextStyle,
  })  : _currentCenter = center,
        _currentScale = scale,
        _currentAngle = angle,
        _currentOpacity = opacity,
        _elapsed = 0 {
    _sprite = TextSprite(
      score.toString(),
      style: style.copyWith(color: style.color.withOpacity(_currentOpacity)),
    );
    _scaleX = scaleTo.dx - scale.dx;
    _scaleY = scaleTo.dy - scale.dy;
  }

  bool done() => _elapsed >= duration.inMilliseconds;

  void update(double dt) {
    _elapsed += dt;
    if (done()) return;

    final percent = _elapsed / duration.inMilliseconds;
    _updateCenter(percent);
    _updateScale(percent);
    _updateAngle(percent);
    _updateOpacity(percent);
  }

  void render(Canvas canvas) {
    if (done()) return;
    _sprite.renderCentered(
      canvas,
      _currentCenter,
      angle: _currentAngle,
      scale: _currentScale,
    );
  }

  void _updateCenter(double percent) {
    if (translateBy == Offset.zero) return;
    final dx = translateBy.dx * percent;
    final dy = translateBy.dy * percent;
    _currentCenter = center.translate(dx, dy);
  }

  void _updateScale(double percent) {
    if (_scaleX == 0 && _scaleY == 0) return;
    final dx = _scaleX * percent;
    final dy = _scaleY * percent;
    _currentScale = scale.translate(dx, dy);
  }

  void _updateAngle(double percent) {
    if (rotateBy == 0) return;
    final delta = rotateBy * percent;
    _currentAngle = angle + delta;
  }

  void _updateOpacity(double percent) {
    if (fadeBy == 0) return;
    final delta = fadeBy * percent;
    _currentOpacity = opacity - delta;
    _sprite.updateOpacity(_currentOpacity);
  }
}
