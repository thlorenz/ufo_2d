import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

class GameKeyboard {
  final Subject<PhysicalKeyboardKey> _keyDown$;

  GameKeyboard._() : _keyDown$ = PublishSubject() {
    RawKeyboard.instance.addListener(
      (RawKeyEvent e) => _keyDown$.add(e.physicalKey),
    );
  }

  Stream<PhysicalKeyboardKey> get keyDown$ => _keyDown$;

  static final GameKeyboard instance = GameKeyboard._();
}
