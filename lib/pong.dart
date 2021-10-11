import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  Color color = Colors.black;

  late double width;
  late double height;

  double increment = 3;
  int score = 0;
  int level = 1;

  double randX = 1;
  double randY = 1;

  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  late Animation<double> animation;
  late AnimationController controller;

  void checkBorders() {
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - 50 && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY >= height - 50 - batHeight && vDir == Direction.down) {
      // check if the bat is here, otherwise is loose
      if (posX >= batPosition - 50 && posX <= batPosition + 50 + batWidth) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() {
          score++;
          if (score / level == 10) {
            level++;
            increment++;
          }
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  double randomNumber() {
    var ran = new Random();
    int myNum = ran.nextInt(101);
    return (myNum + 50) / 100;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(// use this to knowing an available space in screen
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batHeight = height / 20;
      batWidth = width / 5;

      return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(70, 153, 205, 1.0),
              Color.fromRGBO(58, 132, 180, 1.0),
              Color.fromRGBO(38, 107, 149, 1.0),
              Color.fromRGBO(28, 67, 99, 1.0),
            ],
            radius: 0.8
          )
        ),
        child: Stack(
          children: [
            Positioned(
              child: Ball(),
              top: posY,
              left: posX,
            ), // ball
            Positioned(
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                child: Bat(batWidth, batHeight),
              ),
              bottom: 0,
              left: batPosition,
            ), // bat
            Positioned(
              child: Text(
                'Score: $score',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              top: 25,
              right: 24,
            ),
            Positioned(
              child: Text(
                'Level: $level',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              top: 25,
              left: 24,
            ) // level
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      checkBorders();
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  void showMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Would you like to play again?'),
          actions: [
            gameOver('Yes', () {
              setState(() {
                posX = 0;
                posY = 0;
                score = 0;
                level = 1;
                Navigator.of(context).pop();
                controller.repeat();
              });
            }),
            gameOver('No', () {
              Navigator.of(context).pop();
              dispose();
            }),
          ],
        );
      },
    );
  }

  Widget gameOver(String txt, Function function) {
    return TextButton(
      child: Text(txt),
      onPressed: () {
        function();
      },
    );
  }
}
