import 'dart:math';

import 'package:flame/components.dart';

//Will contain QOL extensions for the transform component 
mixin TransformExtensions {
  //Returns the direction the object is facing 
  Vector2 lookingDirection(double angle){
    return Vector2(
    cos(angle),
    sin(angle),
    );
  }
} 