import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:ufo_2d/types/interfaces.dart';

class GameGestures implements IDisposable {
  final Subject<DragEndDetails> _panEnd$;
  final Subject<DragUpdateDetails> _panUpdate$;

  GameGestures._()
      : _panEnd$ = PublishSubject(),
        _panUpdate$ = PublishSubject();

  Stream<DragEndDetails> get panEnd$ {
    return _panEnd$;
  }

  Stream<DragUpdateDetails> get panUpdate$ {
    return _panUpdate$;
  }

  void onPanEnd(DragEndDetails details) {
    _panEnd$.add(details);
  }

  void onPanUpdate(DragUpdateDetails details) {
    _panUpdate$.add(details);
  }

  void dispose() {
    _panEnd$?.close();
    _panUpdate$?.close();
  }

  static GameGestures _instance = GameGestures._();
  static GameGestures get instance {
    return _instance;
  }

  static reset() {
    _instance.dispose();
    _instance = GameGestures._();
  }
}
