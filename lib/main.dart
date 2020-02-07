import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufo_2d/components/game/game.dart';
import 'package:ufo_2d/levels/level_01.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.init(orientation: DeviceOrientation.portraitUp);
  await Flame.images.loadAll(['background.png', 'ufo.png', 'diamond.png']);
  final size = await Flame.util.initialDimensions();
  runApp(GameWidget(size));
}

class GameWidget extends StatelessWidget {
  final Size gameSize;
  GameWidget(this.gameSize);

  @override
  Widget build(BuildContext context) {
    final level = Level01();
    final game = Game(level)..init(gameSize);
    debugPrint(level.toString());
    return MaterialApp(
      title: 'UFO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 19,
              child: game.widget,
            ),
            Expanded(
              flex: 1,
              child: Text('tools'),
            )
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
