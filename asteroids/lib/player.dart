import 'dart:async';


import 'package:flame/components.dart';

enum PlayerState{idle, flying, dashing}

//Player class, inherits from SpriteAnimationGroupComponent (instead of using base, its called super in Dart.)
class Player extends SpriteAnimationGroupComponent
{

  //The late keyword: It tells the compiler that it isnt directly initialized but it will later.
  //The final keyword: Like const, but at runtime. Once assigned cannot be reassigned. Its like a lock
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation dashAnimation;

  //The speed at which the player will move
  double movespeed = 100;
  double forwardMoveAxis = 0;
  double rotationAxis = 0;

  //The "awake/start" method(like how it's called in unity), called upon component-instantiation.
  @override
  FutureOr<void> onLoad() async{

    idleAnimation = await SpriteAnimation.load("spaceship/spaceship.png",
      SpriteAnimationData.sequenced(amount: 1, stepTime: 10000, textureSize: Vector2(36, 26)));

     dashAnimation = await SpriteAnimation.load("spaceship/spaceship_dash.png",
      SpriteAnimationData.sequenced(amount: 16, stepTime: .025, textureSize: Vector2(34, 26)));

    //I LOVE this system, way more intuitive then the unity version(though that is made more for artists, not really for programmers.)
    //"animations" acts like a filter, you pass in an enum and you get the corrosponding animation (like a dictionary in c#, KvP)
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.dashing: dashAnimation,
    };

    //This sets the current animation with the input being an enum as explained before.
    //Effectively this system is just a statemachine with enums
    current = PlayerState.dashing;
  }

  
}