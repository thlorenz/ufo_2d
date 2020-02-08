import 'dart:ui';

import 'package:flame/spritesheet.dart';
import 'package:ufo_2d/components/background/common.dart';

class BackgroundView {
  final SpriteSheet bgTiles;

  BackgroundView()
      : bgTiles = SpriteSheet(
          imageName: BackgroundConfig.imageName,
          rows: BackgroundConfig.rows,
          columns: BackgroundConfig.columns,
          textureHeight: BackgroundConfig.textureHeight,
          textureWidth: BackgroundConfig.textureWidth,
        );

  void render(Canvas c, List<SpriteSheetRect> spriteSheetRects) {
    for (final x in spriteSheetRects) {
      bgTiles.getSprite(x.col, x.row).renderRect(c, x.rect);
    }
  }
}
