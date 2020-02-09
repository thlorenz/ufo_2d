import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';

class GameGestures {
  final Subject<DragEndDetails> _horizontalDrag$;
  final Subject<DragEndDetails> _verticalDrag$;

  GameGestures._()
      : _horizontalDrag$ = PublishSubject(),
        _verticalDrag$ = PublishSubject();

  Stream<DragEndDetails> get horizontalDrag$ {
    return _horizontalDrag$;
  }

  Stream<DragEndDetails> get verticalDrag$ {
    return _verticalDrag$;
  }

  void onVerticalDragEnd(DragEndDetails details) {
    _verticalDrag$.add(details);
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    _horizontalDrag$.add(details);
  }

  static GameGestures _instance = GameGestures._();
  static GameGestures get instance => _instance;
}
