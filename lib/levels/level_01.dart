import 'package:ufo_2d/levels/level.dart';

class Level01 extends GameLevel {
  String get terrain {
    return '''
|012345678901234567890|
|                     |
|                     |
|                     |
|       d             |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|          d          | 
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     |
|                     | d: diamond pickup
|                     |
|                     |
|                     |
|                     |
|            d        | 
|                     |
|                     |
|                     |
|       p             | p: player
|012345678901234567890|
''';
  }
}
