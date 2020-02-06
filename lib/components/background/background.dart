import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:ufo_2d/components/background/background_view.dart';
import 'package:ufo_2d/components/game/game_model.dart';

class Background extends Component {
  final BackgroundView backgroundView;
  Background() : backgroundView = BackgroundView();

  void render(Canvas c) {
    backgroundView.render(c, GameModel.instance.rect);
  }

  void update(double t) {}
}
