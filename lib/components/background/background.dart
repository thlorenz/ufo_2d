import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:ufo_2d/components/background/background_view.dart';
import 'package:ufo_2d/components/background/common.dart';
import 'package:ufo_2d/components/game/game_model.dart';
import 'package:ufo_2d/types/typedefs.dart';

class Background extends Component {
  final GetTileSize _getTileSize;
  final BackgroundView backgroundView;
  List<SpriteSheetRect> _spriteSheetRects;
  final rnd = new Random();

  Background(this._getTileSize) : backgroundView = BackgroundView();

  void render(Canvas c) {
    if (_spriteSheetRects == null) return;
    backgroundView.render(c, _spriteSheetRects);
  }

  void resize(Size deviceSize) {
    super.resize(deviceSize);
    _spriteSheetRects = _rectsFromFloorTiles(_getTileSize(deviceSize));
  }

  List<SpriteSheetRect> _rectsFromFloorTiles(Size tileSize) {
    const factor = 4;
    final level = GameModel.instance.level;
    final spriteSheetRects = List<SpriteSheetRect>();

    for (int col = 0; col < level.ncols; col += factor) {
      for (int row = 0; row < level.nrows; row += factor) {
        final rect = Rect.fromLTWH(
          col * tileSize.width,
          row * tileSize.height,
          tileSize.width * factor,
          tileSize.height * factor,
        );
        spriteSheetRects.add(
          SpriteSheetRect(
            rect,
            rnd.nextInt(7),
            rnd.nextInt(7),
          ),
        );
      }
    }
    return spriteSheetRects;
  }

  void update(double t) {}
}
