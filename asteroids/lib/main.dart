import 'package:asteroids/asteroid_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = AsteroidsGame();
  runApp(GameWidget(game: game));
}

