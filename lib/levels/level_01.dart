import 'package:ufo_2d/levels/level.dart';

class Level01 extends GameLevel {
  String get terrain {
    return '''
|01234567890123456789|
|                    |
|                d   | 
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|      d             | 
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|       d            |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|                    |
|          d         | 
|                    |
|                    |
|      d             | d: diamond pickup
|                    |
|                    |
|                    |
|                    |
|            d       | 
|                    |
|                    |
|                    |
|     p              | p: player
|01234567890123456789|
''';
  }
}
