import 'dart:async';

import 'package:asteroids/player_systems/player.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class AsteroidsGame extends FlameGame with HasKeyboardHandlerComponents{

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    var player = Player();
    world.add(player);
  }  


  @override
  Color backgroundColor(){
    return Colors.black;
  }

}   