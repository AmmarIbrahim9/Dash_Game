import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(MonopolyGame());
}

class MonopolyGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monopoly Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}
