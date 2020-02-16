import 'package:flutter/material.dart';
import 'package:ufo_2d/common/config.dart';

class HealthWidget extends StatelessWidget {
  final double health;

  const HealthWidget({@required this.health}) : super();

  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width * 0.4;
    final healthWidth = (health / Config.totalHealth) * totalWidth;
    return Container(
      height: 20.0,
      width: totalWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Container(
        margin: EdgeInsets.only(right: totalWidth - healthWidth),
        color: _healthColor(),
      ),
    );
  }

  Color _healthColor() {
    return health > Config.totalHealth * 0.80
        ? Colors.greenAccent
        : health > Config.totalHealth * 0.60
            ? Colors.green
            : health > Config.totalHealth * 0.4
                ? Colors.orange
                : health > Config.totalHealth * 0.2
                    ? Colors.redAccent
                    : Colors.red;
  }
}
