import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';
import 'package:ufo_2d/types/interfaces.dart';

class GameKeyboard implements IDisposable {
  final Subject<PhysicalKeyboardKey> _keyDown$;

  GameKeyboard._() : _keyDown$ = PublishSubject() {
    RawKeyboard.instance.addListener(_onKeydown);
  }

  Stream<PhysicalKeyboardKey> get keyDown$ => _keyDown$;

  void _onKeydown(RawKeyEvent e) => _keyDown$.add(e.physicalKey);

  void dispose() {
    RawKeyboard.instance.removeListener(_onKeydown);
    _keyDown$?.close();
  }

  static GameKeyboard _instance = GameKeyboard._();
  static GameKeyboard get instance {
    return _instance;
  }

  static reset() {
    _instance.dispose();
    _instance = GameKeyboard._();
  }
}
