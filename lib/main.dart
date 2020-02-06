import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufo_2d/components/game/game.dart';
import 'package:ufo_2d/levels/level_01.dart';

Future<void> main() async {
  final level = Level01();
  debugPrint(level.toString());
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.init(orientation: DeviceOrientation.portraitUp);
  await Flame.images.loadAll(['background.png', 'ufo.png', 'diamond.png']);
  final size = await Flame.util.initialDimensions();
  final game = Game(level)..init(size);
  runApp(game.widget);
}
