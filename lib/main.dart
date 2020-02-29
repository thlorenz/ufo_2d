import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return MaterialApp(
      title: 'UFO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          children: [],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  void reassemble() {
    super.reassemble();
  }
}
