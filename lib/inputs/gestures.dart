import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';

class GameGestures {
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

  static final GameGestures instance = GameGestures._();
}
