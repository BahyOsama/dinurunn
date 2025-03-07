import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'cactus.dart';
import 'dino.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // static double marioX = 0;
  // static double marioY = 1;
  // double marioSize = 50;
  // double shroomX = 0.5;
  // double shroomY = 1;
  // double time = 0;
  // double height = 0;
  // double initialHeight = marioY;
  // String direction = "right";
  // bool midrun = false;
  // bool midjump = false;
  static double dinoX = 0;
  static double dinoY = 1;
  double dinoSize = 50;
  double cactusX = 0.5;
  double cactusY = 1;
  double time = 0;
  bool isJumping = false;
  int score = 0;
  double gravity = 0.1;
  double velocity = 0;
  bool isGameOver = false;

  List<Cactus> cacti = [];
  Timer? gameLoop;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      isGameOver = false;
      score = 0;
      dinoX = 0;
      dinoY = 0;
      isJumping = false;
      velocity = 0;
      cacti.clear();
    });

    gameLoop = Timer.periodic(Duration(milliseconds: 30), (timer) {
      gameTick();
    });
  }

  void gameTick() {
    if (isJumping) {
      velocity -= gravity;
      setState(() {
        dinoY -= velocity;
        if (dinoY >= 0) {
          isJumping = false;
          velocity = 0;
        }
      });
    }

    // Update Cacti
    for (var cactus in cacti) {
      cactus.updatePosition();
      if (cactus.x < -1) {
        cacti.remove(cactus);
        score++;
      }

      if (cactus.isColliding(dinoX, dinoY)) {
        gameOver();
      }
    }

    // Add new cactus
    if (random.nextDouble() < 0.03) {
      cacti.add(Cactus(random.nextDouble() * 1.5 + 0.5, -0.2));
    }
  }

  void gameOver() {
    gameLoop?.cancel();
    setState(() {
      isGameOver = true;
    });
  }

  void jump() {
    if (!isJumping) {
      setState(() {
        isJumping = true;
        velocity = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              "images/back.png", // Add an image for background
              fit: BoxFit.cover,
            ),
          ),
          // Dino
          Positioned(
            left: MediaQuery.of(context).size.width * (dinoX + 0.5) - 40,
            top: MediaQuery.of(context).size.height * (dinoY + 0.5) - 40,
            child: Dino(isJumping: isJumping),
          ),
          // Cacti
          ...cacti.map((cactus) => Positioned(
                left: MediaQuery.of(context).size.width * (cactus.x + 0.5) - 20,
                top: MediaQuery.of(context).size.height * (cactus.y + 0.5) - 20,
                child: CactusWidget(),
              )),
          // Score and Game Over
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'Score: $score',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          if (isGameOver)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Game Over!',
                      style: TextStyle(fontSize: 50, color: Colors.red)),
                  Text('Score: $score',
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                  ElevatedButton(
                    onPressed: startGame,
                    child: Text('Restart'),
                  ),
                ],
              ),
            ),
        ],
      ),

      // Listen to user input to jump
      bottomNavigationBar: GestureDetector(
        onTap: jump,
        child: Container(
          color: Colors.transparent,
          height: 100,
          child: Center(
            child: Text(
              'Tap to Jump',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
