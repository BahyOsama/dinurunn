import 'package:flutter/material.dart';

class Dino extends StatelessWidget {
  final bool isJumping;

  const Dino({Key? key, required this.isJumping}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/dino.png',
      width: 40,
      height: 40,
      color: isJumping ? Colors.transparent : null,
    );
  }
}
