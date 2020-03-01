import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufo_2d/game/game.dart';
import 'package:ufo_2d/levels/levels.dart';
import 'package:ufo_2d/levels/tilemap.dart';
import 'package:ufo_2d/models/game_model.dart';

Tilemap getTilemap() {
  final level = Levels.walls;
  return Tilemap.build(level);
}

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
  final deviceSize = await Flame.util.initialDimensions();
  runApp(GameWidget(deviceSize));
}

class GameWidget extends StatefulWidget {
  final Size deviceSize;
  GameWidget(this.deviceSize);

  @override
  _GameWidgetState createState() {
    return _GameWidgetState();
  }
}

class _GameWidgetState extends State<GameWidget> {
  Widget build(BuildContext context) {
    final tilemap = getTilemap();
    final getGame = GameModel.getGame;
    final model = GameModel.initFrom(tilemap);
    final game = UfoGame(getGame: getGame, tilemap: tilemap, model: model);
    debugPrint('$game');
    return MaterialApp(
      title: 'UFO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          children: [game.widget],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  void reassemble() {
    super.reassemble();
  }
}
