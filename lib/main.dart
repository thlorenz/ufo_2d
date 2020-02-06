import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufo_2d/components/game/game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.init(orientation: DeviceOrientation.portraitUp);
  await Flame.images.loadAll(['background.png', 'ufo.png']);
  final size = await Flame.util.initialDimensions();
  final game = Game()..init(size);
  runApp(game.widget);
}
