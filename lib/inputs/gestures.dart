import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:ufo_2d/admin/game_props.dart';

class AggregatedGestures {
  final double rotation;
  final double thrust;
  final bool shot;

  AggregatedGestures({
    @required this.rotation,
    @required this.thrust,
    @required this.shot,
  });
}

class GameGestures {
  double _rotation;
  double _thrust;
  bool _shot;
  GameGestures._()
      : _rotation = 0.0,
        _thrust = 0.0,
        _shot = false;

  void onPanUpdate(DragUpdateDetails details) {
    final delta = details.delta;
    if (delta.dx.abs() > delta.dy.abs()) {
      _addRotation(delta.dx);
    } else if (delta.dy < -GameProps.gesturePlayerMinThrustDelta) {
      _addThrust(delta.dy);
    }
  }

  void onTap() {
    debugPrint('tap');
    _shot = true;
  }

  void _addRotation(double amount) {
    _rotation += amount * GameProps.gesturePlayerRotationFactor;
  }

  void _addThrust(double amount) {
    _thrust += amount * GameProps.gesturePlayerThrustFactor;
  }

  AggregatedGestures get aggregatedGestures {
    final gestures = AggregatedGestures(
      rotation: _rotation,
      thrust: _thrust,
      shot: _shot,
    );
    _rotation = 0;
    _thrust = 0;
    _shot = false;
    return gestures;
  }

  static GameGestures _instance = GameGestures._();
  static GameGestures get instance {
    return _instance;
  }
}
