import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:ufo_2d/common/config.dart';
import 'package:ufo_2d/components/background/background_view.dart';
import 'package:ufo_2d/components/background/common.dart';
import 'package:ufo_2d/components/game/game_model.dart';

class Background extends Component {
  final BackgroundView backgroundView;
  List<SpriteSheetRect> _spriteSheetRects;
  final rnd = new Random();

  Background() : backgroundView = BackgroundView();

  void render(Canvas c) {
    if (_spriteSheetRects == null) return;
    backgroundView.render(c, _spriteSheetRects);
  }

  void resize(Size deviceSize) {
    super.resize(deviceSize);
    _spriteSheetRects = _rectsFromFloorTiles(Config.tileSize);
  }

  List<SpriteSheetRect> _rectsFromFloorTiles(Size tileSize) {
    const factor = 4;
    final level = GameModel.instance.level;
    final spriteSheetRects = List<SpriteSheetRect>();

    for (int col = 0; col < level.ncols - 1; col += factor) {
      for (int row = 0; row < level.nrows - 1; row += factor) {
        final rect = Rect.fromLTWH(
          col * tileSize.width,
          row * tileSize.height,
          tileSize.width * factor,
          tileSize.height * factor,
        );
        spriteSheetRects.add(
          SpriteSheetRect(
            rect,
            Config.backgroundTilesRandom ? rnd.nextInt(7) : (row + col) % 7,
            Config.backgroundTilesRandom ? rnd.nextInt(7) : (row - col) % 7,
          ),
        );
      }
    }
    return spriteSheetRects;
  }

  void update(double t) {}
}
