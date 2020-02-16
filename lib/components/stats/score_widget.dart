import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final int score;
  ScoreWidget({@required this.score}) : super();

  Widget build(BuildContext context) {
    return Text(
      'Score: $score',
      style: TextStyle(color: Colors.amber),
    );
  }
}
