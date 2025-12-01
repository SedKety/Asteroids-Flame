import 'dart:async';

import 'package:asteroids/asteroid_systems/asteroid_spawner.dart';
import 'package:asteroids/player_systems/player.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class AsteroidsGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  //Points the player has earned
  int points = 0;

  late dynamic player;

  @override
  FutureOr<void> onLoad() async{
    super.onLoad();

    player = Player();
    add(player);


    var asteroidSpawner = AsteroidSpawner();
    add(asteroidSpawner);

    var background = SpriteComponent();
    background.sprite = await Sprite.load("backgrounds/game_background.jpg");
    background.priority = -1;
    background.scale  = background.scale * .5;
    background.position += Vector2(0, 15);
    add(background);
  }  


  @override
  Color backgroundColor(){
    return Colors.black;
  }

}   