import 'package:flutter/services.dart';

enum GameKey { Up, Down, Left, Right, Button1 }

GameKey _toGameKey(PhysicalKeyboardKey e) {
  if (e == PhysicalKeyboardKey.arrowUp || e == PhysicalKeyboardKey.keyW) {
    return GameKey.Up;
  } else if (e == PhysicalKeyboardKey.arrowRight ||
      e == PhysicalKeyboardKey.keyD) {
    return GameKey.Right;
  } else if (e == PhysicalKeyboardKey.arrowDown ||
      e == PhysicalKeyboardKey.keyS) {
    return GameKey.Down;
  } else if (e == PhysicalKeyboardKey.arrowLeft ||
      e == PhysicalKeyboardKey.keyA) {
    return GameKey.Left;
  } else if (e == PhysicalKeyboardKey.space) {
    return GameKey.Button1;
  }
  return null;
}

class GameKeyboard {
  static Iterable<GameKey> get pressedKeys {
    return RawKeyboard.instance.physicalKeysPressed
        .map(_toGameKey)
        .where((x) => x != null);
  }
}
