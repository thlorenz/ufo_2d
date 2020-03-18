import 'dart:ui' show Canvas, Color, Offset, TextAlign, TextDirection;

import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

class TextSprite {
  final String text;
  TextPainter _textPainter;

  TextSprite(
    this.text, {
    TextStyle style = defaultTextStyle,
    TextAlign textAlign = TextAlign.left,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final span = TextSpan(
      style: style,
      text: text,
    );
    _textPainter = TextPainter(
      text: span,
      textAlign: textAlign,
      textDirection: textDirection,
    )..layout();
  }

  void renderCentered(
    Canvas canvas,
    Offset center, {
    double angle = 0,
    Offset scale = const Offset(1.0, 1.0),
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.scale(scale.dx, -scale.dy);
    _textPainter.paint(
      canvas,
      Offset(-_textPainter.width / 2, -_textPainter.height / 2),
    );
    canvas.restore();
  }

  void updateOpacity(double opacity) {
    final current = _textPainter.text.style;
    final style = current.copyWith(color: current.color.withOpacity(opacity));
    _textPainter.text = TextSpan(style: style, text: text);
    _textPainter.layout();
  }

  static const defaultTextStyle = const TextStyle(
    fontSize: 14.0,
    color: const Color(0xFF000000),
    fontFamily: 'PressStart2P',
  );
}
