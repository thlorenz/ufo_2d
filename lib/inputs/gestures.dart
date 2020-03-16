import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:ufo_2d/admin/game_props.dart';

class AggregatedGestures {
  final double rotation;
  final double thrust;

  AggregatedGestures({@required this.rotation, @required this.thrust});
}

class GameGestures {
  double _rotation;
  double _thrust;
  GameGestures._()
      : _rotation = 0.0,
        _thrust = 0.0;

  void onPanUpdate(DragUpdateDetails details) {
    final delta = details.delta;
    if (delta.dx.abs() > delta.dy.abs()) {
      _addRotation(delta.dx);
    } else if (delta.dy < -GameProps.gesturePlayerMinThrustDelta) {
      _addThrust(delta.dy);
    }
  }

  void _addRotation(double amount) {
    _rotation += amount * GameProps.gesturePlayerRotationFactor;
  }

  void _addThrust(double amount) {
    _thrust += amount * GameProps.gesturePlayerThrustFactor;
  }

  AggregatedGestures get aggregatedGestures {
    final gestures = AggregatedGestures(rotation: _rotation, thrust: _thrust);
    _rotation = 0;
    _thrust = 0;
    return gestures;
  }

  static GameGestures _instance = GameGestures._();
  static GameGestures get instance {
    return _instance;
  }
}
