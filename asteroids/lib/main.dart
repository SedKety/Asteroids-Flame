import 'package:asteroids/asteroid_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

late AsteroidsGame game;
void main() {
  game = AsteroidsGame( restartFunc: restart);
  runApp(GameWidget(game: game));
}
void restart(){
  game.removeFromParent();
  main();
} 