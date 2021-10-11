import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  const Ball({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double diam = 50;

    return Container(
      width: diam,
      height: diam,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color.fromRGBO(206, 143, 143, 1.0),
            Color.fromRGBO(227, 55, 55, 1.0),
            Color.fromRGBO(229, 30, 30, 1.0),
            Color.fromRGBO(142, 9, 9, 1.0),
          ],
          focal: Alignment.topRight,
          radius: 1
        )
      ),
    );
  }
}
