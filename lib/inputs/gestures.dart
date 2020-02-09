import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';

class GameGestures {
  final Subject<DragEndDetails> _horizontalDragEnd$;
  final Subject<DragEndDetails> _verticalDragEnd$;
  final Subject<DragUpdateDetails> _horizontalDragUpdate$;
  final Subject<DragUpdateDetails> _verticalDragUpdate$;

  GameGestures._()
      : _horizontalDragEnd$ = PublishSubject(),
        _verticalDragEnd$ = PublishSubject(),
        _horizontalDragUpdate$ = PublishSubject(),
        _verticalDragUpdate$ = PublishSubject();

  Stream<DragEndDetails> get horizontalDragEnd$ {
    return _horizontalDragEnd$;
  }

  Stream<DragEndDetails> get verticalDragEnd$ {
    return _verticalDragEnd$;
  }

  Stream<DragUpdateDetails> get horizontalDragUpdate$ {
    return _horizontalDragUpdate$;
  }

  Stream<DragUpdateDetails> get verticalDragUpdate$ {
    return _verticalDragUpdate$;
  }

  void onVerticalDragEnd(DragEndDetails details) {
    _verticalDragEnd$.add(details);
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    _horizontalDragEnd$.add(details);
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    _verticalDragUpdate$.add(details);
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    _horizontalDragUpdate$.add(details);
  }

  static GameGestures _instance = GameGestures._();
  static GameGestures get instance => _instance;
}
