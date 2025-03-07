import 'dart:math';

import 'package:flutter/material.dart';

class Cactus {
  double x;
  double y;
  double speed = -4;

  Cactus(this.x, this.y) {
    speed = 0.05 + Random().nextDouble() * 0.05;
  }

  void updatePosition() {
    x -= speed;
  }

  bool isColliding(double dinoX, double dinoY) {
    // Simple collision detection
    return x < dinoX + 0.1 &&
        x > dinoX - 0.1 &&
        y < dinoY + 0.1 &&
        y > dinoY - 0.1;
  }
}

class CactusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/cactus.png', // Add an image for cactus
      width: 50,
      height: 50,
    );
  }
}
