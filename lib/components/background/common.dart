import 'dart:ui';

class BackgroundConfig {
  static const imageName = 'bg/floor-8x8.png';
  static const rows = 8;
  static const columns = 8;
  static const textureHeight = 128;
  static const textureWidth = 128;
}

class SpriteSheetRect {
  final Rect rect;
  final int col;
  final int row;

  SpriteSheetRect(this.rect, this.col, this.row);
}
