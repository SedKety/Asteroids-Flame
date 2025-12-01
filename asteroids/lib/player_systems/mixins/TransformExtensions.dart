import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

//Will contain QOL extensions for the transform component 
mixin TransformExtensions {
  //Returns the direction the object is facing 
  Vector2 lookingDirection(double angle){
    return Vector2(
    cos(angle),
    sin(angle),
    );
  }
   // Screen wrapping (Asteroids-style)
void wrapAroundScreen(Game game, Vector2 position) {
  final screenSize = game.size;

  if (position.x > screenSize.x) {
    position.x = 0;
  } else if (position.x < 0) {
    position.x = screenSize.x;
  }

  if (position.y > screenSize.y) {
    position.y = 0;
  } else if (position.y < 0) {
    position.y = screenSize.y;
  }
}
} 