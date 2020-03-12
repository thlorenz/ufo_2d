import 'package:flutter/services.dart';

enum GameKey { Up, Down, Left, Right }

class GameKeyboard {
  final Set<GameKey> _keys = Set<GameKey>();

  GameKeyboard._() {
    RawKeyboard.instance.addListener(_onKeydown);
  }

  void _onKeydown(RawKeyEvent e) {
    if (e.physicalKey == PhysicalKeyboardKey.arrowUp ||
        e.physicalKey == PhysicalKeyboardKey.keyW) {
      _keys.add(GameKey.Up);
    } else if (e.physicalKey == PhysicalKeyboardKey.arrowRight ||
        e.physicalKey == PhysicalKeyboardKey.keyD) {
      _keys.add(GameKey.Right);
    } else if (e.physicalKey == PhysicalKeyboardKey.arrowDown ||
        e.physicalKey == PhysicalKeyboardKey.keyS) {
      _keys.add(GameKey.Down);
    } else if (e.physicalKey == PhysicalKeyboardKey.arrowLeft ||
        e.physicalKey == PhysicalKeyboardKey.keyA) {
      _keys.add(GameKey.Left);
    }
  }

  Iterable<GameKey> get pressedKeys sync* {
    for (final k in _keys) {
      yield k;
    }
    _keys.clear();
  }

  void dispose() {
    RawKeyboard.instance.removeListener(_onKeydown);
  }

  static GameKeyboard _instance = GameKeyboard._();
  static GameKeyboard get instance => _instance;

  static void reset() {
    _instance.dispose();
    _instance = GameKeyboard._();
  }
}
