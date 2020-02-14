import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufo_2d/common/audio.dart';
import 'package:ufo_2d/components/game/game.dart';
import 'package:ufo_2d/inputs/keyboard.dart';
import 'package:ufo_2d/levels/level_01.dart';

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
    final level = Level01();
    return _GameWidgetState(level);
  }
}

class _GameWidgetState extends State<GameWidget> {
  final GameLevel level;

  _GameWidgetState(this.level);

  @override
  Widget build(BuildContext context) {
    final game = Game(level, widget.deviceSize);
    return MaterialApp(
      title: 'UFO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: game.widget,
            ),
            /*
            Expanded(
              flex: 1,
              child: Text('tools'),
            )
             */
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
