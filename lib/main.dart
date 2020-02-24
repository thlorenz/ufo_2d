import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufo_2d/common/audio.dart';
import 'package:ufo_2d/components/game/game.dart';
import 'package:ufo_2d/components/stats/health_widget.dart';
import 'package:ufo_2d/components/stats/score_widget.dart';
import 'package:ufo_2d/inputs/keyboard.dart';
import 'package:ufo_2d/levels/level_01.dart';

import 'components/game/game_model.dart';
import 'components/stats/stats_model.dart';
import 'inputs/gestures.dart';
import 'levels/level.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await Flame.init(
      orientation: DeviceOrientation.portraitUp,
      fullScreen: false,
    );
  }

  await Flame.images.loadAll([
    'bg/background.png',
    'bg/floor-8x8.png',
    'static/diamond.png',
    'static/wall-metal.png',
    'static/blackhole.png',
    'sprites/rocket-fire.png',
    'ufo.png',
  ]);
  Audio.instance.loadAll();
  final deviceSize = await Flame.util.initialDimensions();
  runApp(GameWidget(deviceSize));
}

class GameWidget extends StatefulWidget {
  final Size deviceSize;
  GameWidget(this.deviceSize);

  @override
  _GameWidgetState createState() {
    final level = Level1.build();
    return _GameWidgetState(level);
  }
}

class _GameWidgetState extends State<GameWidget> {
  final GameLevel level;

  _GameWidgetState(this.level);

  @override
  Widget build(BuildContext context) {
    final player = GameModel.getPlayer();
    GameModel.set(null);
    final level = Level1.build();
    final game = Game(level, widget.deviceSize);
    if (GameModel.instance != null) GameModel.setPlayer(player);
    return MaterialApp(
      title: 'UFO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            game.widget,
            StreamBuilder(
              stream: GameModel.statsUpdate$,
              builder: (_, AsyncSnapshot<StatsModel> snapshot) =>
                  Hud(model: snapshot.data),
              initialData: GameModel.getStats(),
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  void reassemble() {
    GameGestures.reset();
    GameKeyboard.reset();
    super.reassemble();
  }
}

class Hud extends StatelessWidget {
  final StatsModel model;

  const Hud({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0x66000000),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ScoreWidget(score: model.score),
              Padding(padding: const EdgeInsets.only(left: 20.0)),
              HealthWidget(health: model.health),
            ],
          ),
        ));
  }
}
