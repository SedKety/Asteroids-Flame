import 'dart:async';

import 'package:asteroids/asteroid_systems/asteroid_spawner.dart';
import 'package:asteroids/player_systems/player.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class AsteroidsGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    var player = Player();
    world.add(player);


    var asteroidSpawner = AsteroidSpawner();
    world.add(asteroidSpawner);
  }  


  @override
  Color backgroundColor(){
    return Colors.black;
  }

}   