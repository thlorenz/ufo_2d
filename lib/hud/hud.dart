import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ufo_2d/hud/health_widget.dart';
import 'package:ufo_2d/hud/score_widget.dart';
import 'package:ufo_2d/models/hud_model.dart';

class Hud extends StatelessWidget {
  final HudModel model;

  const Hud({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0x66000000),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ScoreWidget(score: model.score),
              Padding(padding: const EdgeInsets.only(left: 20.0)),
              HealthWidget(health: model.health),
            ],
          ),
        ));
  }
}
